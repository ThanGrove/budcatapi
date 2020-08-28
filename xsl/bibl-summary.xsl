<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0">
    
    <xsl:output method="text" 
        encoding="UTF-8" 
        indent="no"/>
    
    <xsl:include href="genvars.xsl"/>
    
    <xsl:template match="/">
        <xsl:text>{</xsl:text>
            <xsl:apply-templates />
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tibbibl[@level='text']">
        "id": "<xsl:value-of select="@id"/>",
        <xsl:apply-templates/>
    </xsl:template>
       
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
        ]
    </xsl:template>
    
    <xsl:template match="* | text()"/>
</xsl:stylesheet>