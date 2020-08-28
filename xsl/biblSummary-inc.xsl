<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0">

	
            <xsl:strip-space elements="*" />
	<xsl:template name="tibbiblJSON">
		<div class="json" style="display: none;">
			{
			<xsl:choose>
				<xsl:when test="$edid='main'">
					<xsl:apply-templates select="/*/tibiddecl" mode="doIdInfoSingleEd"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="/*/tibiddecl" mode="doIdInfoMultiEd"/>
				</xsl:otherwise>
			</xsl:choose>
				<xsl:call-template name="doPaginationJSON"/>
				"title": {
					<xsl:apply-templates select="/*/titlegrp//title[contains(@type,'normalized')]" mode="doTitle"/>
					"end": "end"
				},
				<xsl:call-template name="doSectionsJSON"/>,
				<xsl:call-template name="doResourcesJSON"/>
			}
		</div>
	</xsl:template>
	
	<xsl:template match="tibiddecl" mode="doIdInfoSingleEd">
		<xsl:variable name="tnum" select="$txtid"/>
		<xsl:variable name="ftnum" select="format-number(number($tnum),'0000')"/>
		<xsl:variable name="parentCat"><xsl:choose>
			<xsl:when test="/*//resources//xref[@n='parent-cat']"><xsl:value-of select="concat('../xml/',/*//resources//xref[@n='parent-cat']/text())"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat('../xml/',(tibid[@type='collection' and 
				@system='sigla'])[1]/text(),'/',(tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/text(),'/',(tibid[@type='collection' and 
				@system='sigla'])[1]/text(),'-',(tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/text(),'-cat.xml')"/></xsl:otherwise>
		</xsl:choose></xsl:variable>
		"coll": "<xsl:value-of select="$collid"/>",
		"ed": {
		"eng": "<xsl:value-of select="normalize-space((tibid[@type='collection' and @system='letter'])[1]/text()[1])"/>",
		"tib": "<xsl:value-of select="normalize-space((tibid[@type='collection' and @system='letter'])[1]/altid/text())"/>",
		"wyl": "<xsl:value-of select="translate((tibid[@type='collection' and @system='letter'])[1]/altid/comment(),'[]\','')"/>",
		"sigla": "main"},
		"vols": [<xsl:for-each select="(.//tibid[@type='collection' and @system='sigla'])[1]/tibid[@type='volume']">
			<xsl:variable name="voldoc" select="concat('../xml/',$collid,'/volumes/',$collid,'-v',
				format-number(number(text()),'000'),'-bib.xml')"/>
			{"num": "<xsl:value-of select="text()"/>", 	
			"tib": "<xsl:value-of select="altid[@lang='tib']/text()"/>", 
			"wyl": "<xsl:value-of select="translate(altid[@lang='tib']/comment(),'[]',']')"/>",
			"voldoc": "<xsl:value-of select="$voldoc"/>",
			"voladj": "<xsl:value-of select="document($voldoc)//extent[@class='sides-before-1a']/text()"/>"}<xsl:if 
				test="(./following-sibling::tibid)[1]/@type='volume'">, </xsl:if>
		</xsl:for-each>],
		"text": "<xsl:value-of select="$tnum"/>",
		"isMaster":  "<xsl:choose><xsl:when test="/*//tibiddecl/@rend='master'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>",
		"master": "<xsl:value-of select="/*/tibiddecl/idno[@type='master' and @n='fmpdb']/text()"/>",
		"doxID": "<xsl:value-of select="document($parentCat)//xptr[number(@n)=number($ftnum)]/../../@id"/>",
	</xsl:template>
	
	<xsl:template match="tibiddecl" mode="doIdInfoMultiEd">
		<xsl:variable name="tnum" select="(tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/tibid[1]/text()"/>
		<xsl:variable name="ftnum" select="format-number(number($tnum),'0000')"/>
		<xsl:variable name="parentCat"><xsl:choose>
			<xsl:when test="/*//resources//xref[@n='parent-cat']"><xsl:value-of select="concat('../xml/',/*//resources//xref[@n='parent-cat']/text())"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat('../xml/',(tibid[@type='collection' and 
				@system='sigla'])[1]/text(),'/',(tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/text(),'/',(tibid[@type='collection' and 
				@system='sigla'])[1]/text(),'-',(tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/text(),'-cat.xml')"/></xsl:otherwise>
		</xsl:choose></xsl:variable>
		"coll": "<xsl:value-of select="normalize-space((tibid[@type='collection' and @system='sigla'])[1]/text())"/>",
		"ed": {
			"eng": "<xsl:value-of select="normalize-space((tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/text())" />",
			"tib": "<xsl:value-of select="normalize-space((tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/altid/text())"/>",
			"wyl": "<xsl:value-of select="normalize-space(translate((tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/altid/comment(),'[]\',''))"/>",
			"sigla": "<xsl:value-of select="normalize-space((tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/text())"/>"},
		"vols": [<xsl:for-each select="(tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/tibid[@type='volume']">
				<xsl:variable name="voldoc" select="concat('../xml/',$collid,'/',$edid,'/volumes/',$collid,'-',$edid,'-v',
					format-number(number(text()),'000'),'-bib.xml')"/>
				{"num": "<xsl:value-of select="text()"/>", 	
				"tib": "<xsl:value-of select="altid[@lang='tib']/text()"/>", 
				"wyl": "<xsl:value-of select="translate(altid[@lang='tib']/comment(), '[]\','')"/>",
				"voldoc": "<xsl:value-of select="$voldoc"/>",
				"voladj": "<xsl:value-of select="document($voldoc)//extent[@class='sides-before-1a']/text()"/>"}<xsl:if 
					test="(./following-sibling::tibid)[1]/@type='volume'">, </xsl:if>
		</xsl:for-each>],
		"text": "<xsl:value-of select="$tnum"/>",
		"master": "<xsl:value-of select="/*/tibiddecl/idno[@type='master' and @n='fmpdb']/text()"/>",
		"doxID": "<xsl:value-of select="document($parentCat)//xptr[number(@n)=number($ftnum)]/../../@id"/>",
	</xsl:template>
	
	<xsl:template match="text()" mode="doIdInfo"/>
	
	<xsl:template name="doPaginationJSON">
		"pages": [<xsl:choose>
			<xsl:when test="/*/physdecl/pagination/rs[@type='vol']">
				<xsl:for-each select="/*/physdecl/pagination/rs[@type='vol']">
			{
				"vol": "<xsl:value-of select="@n"/>",
				"start": {
					"vol": "<xsl:choose>
						<xsl:when test="rs[@type='pagination' and @n='start']/num[@type='vol']"><xsl:value-of 
							select="rs[@type='pagination' and @n='start']/num[@type='vol']"/></xsl:when>
						<xsl:when test="(/*/tibiddecl/tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/tibid[@type='volume']"><xsl:value-of 
							select="((/*/tibiddecl/tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/tibid[@type='volume'])[1]/text()"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="@n"/></xsl:otherwise>
					</xsl:choose>",
					"page": "<xsl:value-of select="translate(rs[@type='pagination' and @n='start']/num[@type='page'],'ab','')"/>",
					"side": "<xsl:choose>
						<xsl:when test="contains(rs[@type='pagination' and @n='start']/num[@type='page'],'a')">a</xsl:when>
						<xsl:when test="contains(rs[@type='pagination' and @n='start']/num[@type='page'],'b')">b</xsl:when>
					</xsl:choose>",
					"line": "<xsl:value-of select="rs[@type='pagination' and @n='start']/num[@type='line']"/>"
				},
				"end": {
					"vol": "<xsl:choose>
						<xsl:when test="rs[@type='pagination' and @n='end']/num[@type='vol']"><xsl:value-of 
							select="rs[@type='pagination' and @n='end']/num[@type='vol']"/></xsl:when>
						<xsl:when test="(/*/tibiddecl/tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/tibid[@type='volume']"><xsl:value-of select="((/*/tibiddecl/tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/tibid[@type='volume'])[position()=last()]/text()"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="@n"/></xsl:otherwise>
					</xsl:choose>",
					"page": "<xsl:value-of select="translate(rs[@type='pagination' and @n='end']/num[@type='page'],'ab','')"/>",
					"side": "<xsl:choose>
						<xsl:when test="contains(rs[@type='pagination' and @n='end']/num[@type='page'],'a')">a</xsl:when>
						<xsl:when test="contains(rs[@type='pagination' and @n='end']/num[@type='page'],'b')">b</xsl:when>
					</xsl:choose>",
					"line": "<xsl:value-of select="rs[@type='pagination' and @n='end']/num[@type='line']"/>"
				}
				}<xsl:if test="following-sibling::rs[@type='vol']">, </xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="tvol" select="(/*/tibiddecl//tibid[@type='volume' and @system='number'])[1]/text()[1]"/>
				{
					"vol": "<xsl:value-of select="$tvol"/>",
					"start": {
						"vol": "<xsl:value-of select="$tvol"/>",
						"page": "<xsl:value-of select="translate(/*/physdecl/pagination/rs[@n='start']/num[@type='page']/text(),'ab','')"/>",
						"side": "<xsl:value-of select="translate(/*/physdecl/pagination/rs[@n='start']/num[@type='page']/text(),'0123456789','')"/>",
						"line": "<xsl:value-of select="/*/physdecl/pagination/rs[@n='start']/num[@type='line']/text()"/>"
					},
					"end": {
						"vol": "<xsl:value-of select="$tvol"/>",
						"page": "<xsl:value-of select="translate(/*/physdecl/pagination/rs[@n='end']/num[@type='page']/text(),'ab','')"/>",
						"side": "<xsl:value-of select="translate(/*/physdecl/pagination/rs[@n='end']/num[@type='page']/text(),'0123456789','')"/>",
						"line": "<xsl:value-of select="/*/physdecl/pagination/rs[@n='end']/num[@type='line']/text()"/>"
					}
				}
			</xsl:otherwise>
		</xsl:choose>],
	</xsl:template>
	
	<xsl:template match="title" mode="doTitle">
		<xsl:choose>
			<xsl:when test="@lang='tib'">
				"tib": "<xsl:value-of select="normalize-space(.)"/>",
				"wyl": "<xsl:value-of select="translate(normalize-space(comment()),'[]\','')"/>",
			</xsl:when>
			<xsl:when test="@lang='san'">
				"san": "<xsl:value-of select="."/>",
			</xsl:when>
			<xsl:when test="@lang='eng'">
				"eng": "<xsl:value-of select="."/>",
			</xsl:when>
			<xsl:otherwise>
				"other": "<xsl:value-of select="."/>",
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="text()" mode="doTitle" />
	
	<xsl:template name="doSectionsJSON">
		"sections": <xsl:choose><xsl:when test="/*//sections/tibanal/tibbibl">[
			<xsl:for-each select="/*//sections/tibanal/tibbibl">
				<xsl:call-template name="jsonizeTibbibl"/><xsl:if test="following::tibbibl or parent::tibanal/following-sibling::tibanal">, </xsl:if>
			</xsl:for-each>
			]</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="jsonizeTibbibl">
		<xsl:if test="not(@n='a0') and not(@n='c0')">
			<xsl:variable name="mytype"><xsl:value-of select="@level"/></xsl:variable>
			<xsl:variable name="myid"><xsl:choose>
				<xsl:when test="@n"><xsl:value-of select="@n"/></xsl:when>
				<xsl:when test="tibiddecl[1]/tibid[@type=$mytype
					and @system='number']/text()"><xsl:value-of 
						select="normalize-space(./tibiddecl[1]/tibid[@type=$mytype
						and @system='number']/text())"/></xsl:when>
			</xsl:choose></xsl:variable>
			{
				"id": "<xsl:value-of select="$myid"/>",
				"type": "<xsl:value-of select="@level"/>",
				"head": "<xsl:choose>
					<xsl:when test="head/text()"><xsl:value-of select="head"/></xsl:when>
					<xsl:when test="titledecl/title[@lang='eng']/text()"><xsl:value-of select="titledecl/title[@lang='eng']/text()"/></xsl:when>
					<xsl:when test="contains(comment()[1],'Chapter')"><xsl:value-of select="comment()[1]"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="titledecl/title[@lang='tib']/text()"/></xsl:otherwise>
				</xsl:choose>",
				"title": {
					"tib": "<xsl:call-template name="tibbreak"><xsl:with-param name="txt"><xsl:call-template name="clearTibConvErrs"><xsl:with-param name="ttxt"><xsl:value-of select="titledecl/title[@lang='tib']"/></xsl:with-param></xsl:call-template></xsl:with-param></xsl:call-template>",
					"wyl": "<xsl:value-of select="normalize-space(translate(titledecl/title[@lang='tib']/comment(),'[]\',''))"/>",
					"eng": "<xsl:value-of select="normalize-space(titledecl/title[@lang='eng'])"/>"},
				"start": {
					"vol": "<xsl:choose>
						<xsl:when test="physdecl/pagination/rs[1]/num[@type='vol']"><xsl:value-of 
							select="number(physdecl/pagination/rs[1]/num[@type='vol']/text())"/></xsl:when>
						<xsl:otherwise><xsl:value-of 
							select="((/*/tibiddecl/tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/tibid[@type='volume'])[1]/text()"/></xsl:otherwise>
					</xsl:choose>",
					"page": "<xsl:value-of select="translate(physdecl/pagination/rs[1]/num[@type='page'],'ab','')"/>",
					"side": "<xsl:choose>
						<xsl:when test="contains(physdecl/pagination/rs[1]/num[@type='page'],'a')">a</xsl:when>
						<xsl:when test="contains(physdecl/pagination/rs[1]/num[@type='page'],'b')">b</xsl:when>
					</xsl:choose>",
					"line": "<xsl:value-of select="physdecl/pagination/rs[1]/num[@type='line']"/>"},
				"end": {<xsl:choose>
				<xsl:when test="physdecl/pagination/rs[@n='end']">
					"vol": "<xsl:choose>
						<xsl:when test="physdecl/pagination/rs[@n='end']/num[@type='vol']"><xsl:value-of 
							select="number(physdecl/pagination/rs[@n='end']/num[@type='vol']/text())"/></xsl:when>
						<xsl:otherwise><xsl:value-of 
							select="((/*/tibiddecl/tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/tibid[@type='volume'])[position()=last()]/text()"/></xsl:otherwise>
					</xsl:choose>",
					"page": "<xsl:value-of select="translate(physdecl/pagination/rs[@n='end']/num[@type='page'],'ab','')"/>",
					"side": "<xsl:choose>
						<xsl:when test="contains(physdecl/pagination/rs[@n='end']/num[@type='page'],'a')">a</xsl:when>
						<xsl:when test="contains(physdecl/pagination/rs[@n='end']/num[@type='page'],'b')">b</xsl:when>
					</xsl:choose>",
					"line": "<xsl:value-of select="physdecl/pagination/rs[@n='end']/num[@type='line']"/>"</xsl:when>
				<xsl:otherwise>
					"vol": "<xsl:choose>
						<xsl:when test="physdecl/pagination/rs[1]/num[@type='vol']"><xsl:value-of 
							select="number(physdecl/pagination/rs[1]/num[@type='vol']/text())"/></xsl:when>
						<xsl:otherwise><xsl:value-of 
							select="((/*/tibiddecl/tibid[@type='collection' and @system='sigla'])[1]/tibid[1]/tibid[1]/tibid[@type='volume'])[position()=last()]/text()"/></xsl:otherwise>
					</xsl:choose>",
					"page": "<xsl:value-of select="translate(physdecl/pagination/rs[1]/num[@type='page'],'ab','')"/>",
					"side": "<xsl:choose>
						<xsl:when test="contains(physdecl/pagination/rs[1]/num[@type='page'],'a')">a</xsl:when>
						<xsl:when test="contains(physdecl/pagination/rs[1]/num[@type='page'],'b')">b</xsl:when>
					</xsl:choose>",
					"line": "<xsl:value-of select="physdecl/pagination/rs[1]/num[@type='line']"/>"</xsl:otherwise>
				</xsl:choose>},
				<xsl:if test="not(tibanal/tibbibl)">"haschaps": false</xsl:if>
				<xsl:if test="tibanal/tibbibl">
					"haschaps": true,
					"chaps": [
						<xsl:for-each select="tibanal/tibbibl">
							<xsl:call-template name="jsonizeTibbibl"/><xsl:if test="following::tibbibl or parent::tibanal/following-sibling::tibanal">, </xsl:if>
						</xsl:for-each>
					]
				</xsl:if>
		}</xsl:if>
	</xsl:template>
	
	<xsl:template name="doResourcesJSON">
		<xsl:variable name="parentCat">../xml/<xsl:value-of select="/*//resources/xref[@n='parent-cat']/text()"/></xsl:variable>
		<xsl:variable name="parentRes"><xsl:apply-templates select="/*//resources/xref[not(@n='parent-cat')] | document($parentCat)//xref" mode="getResourcesForBiblSum" /></xsl:variable>
		"hasPageImgs": <xsl:choose>
			<xsl:when test="contains($parentRes,'page-img-loc_')">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>,
		"hasDigText": <xsl:choose>
			<xsl:when test="contains($parentRes,'text_') or contains($parentRes,'texts_')">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>,
		"dbug": "<xsl:value-of select="$parentCat"/>_<xsl:value-of select="$parentRes"/>"
	</xsl:template>
	
	<xsl:template match="resources/xref" mode="getResourcesForBiblSum"><xsl:value-of select="@type" />_</xsl:template>
	
	<xsl:template match="text()" mode="getResourcesForBiblSum" />
	
</xsl:stylesheet>
