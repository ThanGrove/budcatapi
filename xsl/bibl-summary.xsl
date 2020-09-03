<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0">
    <!-- 
        This stylesheet converts a Tibetan Bibliographic record (Tibbibl) XML file into JSON for exporting via an API.
         It was written using for examples the Tibetan Kangyur Tengyur files from the Dege and other editions along with other catalogs from THL.
         It is part of the revamping of the THL catalog system in preparation for the Union Catalog of the Buddhist Tripitaka project.
         
         Than Grove, August, 2020.
    -->
    <xsl:output method="text" 
        encoding="UTF-8" 
        indent="no"/>
    
    <xsl:include href="../xsl/genvars.xsl"/>
    
    <xsl:template match="/">
        <xsl:text>{</xsl:text>
            <xsl:apply-templates />
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <!-- Tibbibl at the very top level -->
    <xsl:template match="tibbibl[@level='text']">
        "id": "<xsl:value-of select="@id"/>",
        <xsl:apply-templates/>
    </xsl:template>
       
       <!-- CONTROL INFO: system/cataloging metadata -->
    <xsl:template match="controlinfo">
        <xsl:variable name="date_cataloged"><xsl:value-of select="date"/></xsl:variable>
        "sysid": "<xsl:value-of select="sysid"/>",
        "agents": [
            <xsl:for-each select="respStmt">
                <xsl:variable name="role" select="replace(translate(resp/text(), $uc, $lc), 'guer', 'ger')" />
                {
                    "role":  "<xsl:value-of select="$role"/>",
                    "name": "<xsl:value-of select="name" />",
                    "date": "<xsl:value-of select="$date_cataloged"/>"
                }<xsl:if test="following-sibling::respStmt or ../revisionDesc/change">,</xsl:if>
            </xsl:for-each>
            <xsl:for-each select="revisionDesc/change">
                {
                    "role":  "<xsl:value-of select="respStmt/resp/text()" />",
                    "name": "<xsl:value-of select="respStmt/name/text()" />",
                    "date": "<xsl:value-of select="date/text()"/>",
                    "description": "<xsl:value-of select="normalize-space(item/text())"/>"
                }<xsl:if test="following-sibling::change">,</xsl:if>
            </xsl:for-each>
        ],
        "parent_cat": "<xsl:value-of select="normalize-space(resources/xref[@n='parent-cat']/text())"/>",
    </xsl:template>
    
    <!-- TEXT TIBIDDECL INFO: ID information -->
    <xsl:template match="tibbibl[@level='text']/tibiddecl/tibid[@type='collection' and @system='sigla']">
        <xsl:variable name="tnum"><xsl:value-of select="normalize-space(tibid[@type='edition' and @system='letter']/tibid[@type='edition' and @system='sigla']/tibid[@type='text' and @system='number']/text()[1])"/></xsl:variable>
        <xsl:variable name="tnumzfill"><xsl:value-of select="substring('0000', 1, (4 - string-length($tnum)))"/><xsl:value-of select="$tnum"/></xsl:variable>
        <xsl:variable name="edsig"><xsl:value-of select="normalize-space(./tibid[@type='edition' and @system='letter']/tibid[@type='edition' and @system='sigla']/text()[1])"/></xsl:variable>
        "collection": "<xsl:value-of select="normalize-space(./text()[1])"/>",
        "edition": {
            "name": "<xsl:value-of select="normalize-space(./tibid[@type='edition' and @system='letter'][1]/text()[1])"/>",
            "sigla": "<xsl:value-of select="$edsig"/>",
            "tibetan": "<xsl:value-of select="normalize-space(./tibid[@type='edition' and @system='letter']/altid[@lang='tib']/text()[1])"/>",
            "wylie": "<xsl:value-of select="normalize-space(./tibid[@type='edition' and @system='letter']/altid[@lang='tib']/comment())"/>"
        },
        "other_editions": [
            <xsl:for-each select="tibid[@type='edition' and @system='letter']">
                <xsl:if test="preceding-sibling::tibid[@type='edition' and @system='letter']">
                    {
                        "sigla": "<xsl:value-of select="normalize-space(./text()[1])"/>",
                        "tnum": "<xsl:value-of select="normalize-space(./tibid[@type='text' and @system='number']/text()[1])"/>",
                        "pagination": "<xsl:value-of select="normalize-space(.//altid[@system='number' and @n='pagination']/text()[1])"/>"
                    }<xsl:if test="following-sibling::tibid[@type='edition' and @system='letter']">,</xsl:if>
                </xsl:if>
            </xsl:for-each>
        ],
        "volumes": [
        <xsl:for-each select="tibid[@type='edition' and @system='letter']/tibid[@type='edition' and @system='sigla']/tibid[@type='volume' and @system='number']">
                <xsl:variable name="vnum" select="normalize-space(./text()[1])"/>
                {
                    "number": "<xsl:value-of select="$vnum"/>",
                    "tibetan": "<xsl:value-of select="normalize-space(altid[@system='letter' and @lang='tib']/text()[1])"/>",
                    "wylie": "<xsl:value-of select="normalize-space(altid[@system='letter' and @lang='tib']/comment())"/>",
                    "num_in_vol": "<xsl:value-of select="normalize-space(tibid[@type='text' and @system='number']/text()[1])"/>",
                    "pagination": "<xsl:apply-templates select="/tibbibl[@level='text']/physdecl/pagination/rs[@type='vol' and @n=$vnum]" mode="getPagination"/>"
                }<xsl:if test="following-sibling::tibid[@type='volume' and @system='number']">,</xsl:if>
            </xsl:for-each>
        ],
        "tnum": "<xsl:value-of select="normalize-space(tibid[@type='edition' and @system='letter']/tibid[@type='edition' and @system='sigla']/tibid[@type='text' and @system='number']/text()[1])"/>",
        "text_label": "<xsl:value-of select="$edsig"/>.<xsl:value-of select="$tnumzfill"/>",
    </xsl:template>
    
    <!-- Physical Information: Extent -->
    <xsl:template match="tibbibl[@level='text']/physdecl">
        <xsl:for-each select="extentdecl">
            "<xsl:value-of select="@type"/>": {
                <xsl:for-each select="extent">
                    "<xsl:value-of select="@class"/>": "<xsl:value-of select="normalize-space(text())"/>"<xsl:if test="following-sibling::extent">,</xsl:if>
                </xsl:for-each>
            },
        </xsl:for-each> 
        <xsl:apply-templates select="divdecl"/>
    </xsl:template>
    
    <!-- Physical Information: Section Summary (object) -->
    <xsl:template match="tibbibl[@level='text']/physdecl/divdecl[@type='cle']">
        <xsl:variable name="isDesignation"><xsl:if test="count(divcount[@class='body']/name[@type='designation']/rs) &gt; 0">yes</xsl:if></xsl:variable>
        "section_summary": {
            <xsl:for-each select="./divcount">
                "<xsl:value-of select="@class"/>":"<xsl:value-of select="normalize-space(text()[1])"/>"<xsl:if test="following-sibling::divcount or $isDesignation='yes'">,</xsl:if>
            </xsl:for-each>
           <xsl:if test="$isDesignation='yes'">
                "designations": [<xsl:for-each select="divcount[@class='body']/name[@type='designation']/rs"><xsl:call-template name="processLang"/><xsl:if test="following-sibling::rs">,</xsl:if></xsl:for-each>]
            </xsl:if>
        },
    </xsl:template>
    
    <!-- Intellectual Classification: Doxography (object of types) -->
    <xsl:template match="tibbibl[@level='text']/intelldecl">
        <xsl:if test="doxography">
            "doxography": {<xsl:apply-templates select="doxography"/>},
        </xsl:if>
        <xsl:apply-templates select="discussion"/>
    </xsl:template>
    
    <!-- Doxography: Display each labelled by type or subtype -->
    <xsl:template match="intelldecl/doxography">
        <xsl:variable name="doxtype"><xsl:choose>
            <xsl:when test="@type='category'"><xsl:value-of select="@subtype"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
        </xsl:choose></xsl:variable>
        "<xsl:value-of select="$doxtype"/>":<xsl:call-template name="processLang"/><xsl:if test="following-sibling::doxography">,</xsl:if>
    </xsl:template>
       
    <xsl:template match="intelldecl/discussion[@type='homage-obj']">
        <xsl:variable name="source"><xsl:value-of select="./source/text()[1]"/> (<xsl:for-each select="./source/rs[@type='pagination']/num"><xsl:if test="@type='vol'">vol. </xsl:if><xsl:value-of 
              select="normalize-space(text())"/><xsl:if test="@type='vol'">, </xsl:if><xsl:if test="@type='page'">.</xsl:if></xsl:for-each>)</xsl:variable>
        "homage":{
            "object": <xsl:call-template name="processLang"/>,
             "source": "<xsl:value-of select="$source"/>"
        }
    </xsl:template>
    
    <!-- rs(mode=getPagination): Takes an rs[@type='vol'] and converts it to a pagination string -->
    <xsl:template match="rs" mode="getPagination"><xsl:choose>
        <xsl:when test="@type='vol'"><xsl:apply-templates select="rs[@n='start']" mode="getPagination"/>-<xsl:apply-templates select="rs[@n='end']" mode="getPagination"/></xsl:when>
        <xsl:when test="@type='pagination'"><xsl:value-of select="num[@type='page']"/>.<xsl:value-of select="num[@type='line']"/></xsl:when>
    </xsl:choose></xsl:template>
    
    <!-- processLang: processes any element with a lang attribute into an object with lang and text properties, if it's Tibetan it uses the comment to fill a third property, wylie -->
    <xsl:template name="processLang">
        <xsl:variable name="lang"><xsl:choose><xsl:when test="@lang"><xsl:value-of select="@lang"/></xsl:when><xsl:otherwise>eng</xsl:otherwise></xsl:choose></xsl:variable>
        {
            "lang":"<xsl:value-of select="$lang"/>",
            "text": "<xsl:value-of select="normalize-space(text()[1])"/>"<xsl:if test="comment()">,
            "wylie": "<xsl:value-of select="comment()"/>"
        </xsl:if>
    }</xsl:template>
    
    <!-- processPage: to display an <rs type="pagination"> which may have 3 <num>s for vol, page, and line -->
    <xsl:template name="processPage">
        
    </xsl:template>
    
    <!-- Keep the stylesheet cascading through the tree -->
    <xsl:template match="*"><xsl:apply-templates /></xsl:template>
    
    <!-- But don't display text except where explicitly indicated (need valid JSON) -->
    <xsl:template match="text()"/>
    
</xsl:stylesheet>