<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="html" indent="yes"/>
	<!-- Passed in parameters -->
	<xsl:variable name="collid">kt</xsl:variable>
	<xsl:variable name="edid">d</xsl:variable>
	<xsl:variable name="txtid">kt-d-0002</xsl:variable>
	 
	<!-- Text Entity type variables -->
	<xsl:variable name="opnbrk">{</xsl:variable>
	<xsl:variable name="clsbrk">}</xsl:variable>
	
	<!-- General Variables used in styles --> 
	<xsl:variable name="lc">abcdefghijklmnopqrstuvwxyzāáàäēéèëiíìïōóòöūúùüḍḥḷḹṃṁṇṅñṛṝśṣṭ</xsl:variable>
	<xsl:variable name="uc">ABCDEFGHIJKLMNOPQRSTUVWXYZĀÁÀÄĒÉÈËĪÍÌÏŌÓÒÖŪÚÙÜḌḤḶḸṂṀṆṄÑṚṜŚṢṬ</xsl:variable>
	<xsl:variable name="catreader">/encyclopedias/literary/php/cat_reader.php?url=</xsl:variable>
	<xsl:variable name="thdl_participants_url">http://www.thlib.org/xml/show.php?xml=/community/xml/thdlpeople.xml&amp;l=</xsl:variable>
	<xsl:variable name="parent_cat">../xml/<xsl:value-of select="$collid"/>/<xsl:if test="not($edid='main')"><xsl:value-of 
		select="$edid"/>/</xsl:if><xsl:value-of select="$collid"/><xsl:if test="not($edid='main')">-<xsl:value-of 
			select="$edid"/></xsl:if>-cat.xml</xsl:variable><!-- /*//resources/xref[@n='parent-cat']/text() -->
	<xsl:variable name="space"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></xsl:variable>
	<xsl:variable name="respdoc">../../xml/thl-resp-db.xml</xsl:variable>
	<xsl:variable name="extWyl">ADHILMNRSTU_+</xsl:variable>
	<xsl:variable name="diaWyl">āḍḥīḷṃṇṛṣṭū &#x200B;</xsl:variable><!-- replacing "+" with zero-width space to prevent it from being replaced by a space -->
	<xsl:variable name="apos">'</xsl:variable>
	

	<!-- Variables used in styles -->
	<xsl:variable name="gentibtitle">
		<xsl:choose>
			<xsl:when test="/*//title[@type='edition-title']/text()">
				<xsl:value-of select="/*//title[@type='edition-title']/text()"/>
			</xsl:when>
			<xsl:when test="/*//title[@type='normalized-title' and @lang='tib']/text()">
				<xsl:value-of select="/*//title[@type='normalized-title']/text()"/>
			</xsl:when>
			<xsl:when test="/*//title[@subtype='title-line']/text()">
				<xsl:value-of select="/*//title[@subtype='title-line']/text()"/>
			</xsl:when>
			<xsl:when test="/*//titlegrp//title[@lang='tib' and not(normalize-space(.)='')][1]">
				<xsl:value-of select="/*//titlegrp//title[@lang='tib' and not(normalize-space(.)='')][1]/text()"/>
			</xsl:when>
			<xsl:when test="/*//titlegrp//title[@lang='eng' and not(normalize-space(.)='')][1]">
				<xsl:value-of select="/*//titlegrp//title[@lang='eng' and not(normalize-space(.)='')][1]/text()"/></xsl:when>
			<xsl:otherwise>
				No title given.
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="genwyltitle">
		<xsl:choose>
			<xsl:when test="/*//title[@type='edition-title']/comment()">
				<xsl:value-of select="translate(/*//title[@type='edition-title']/comment(), $extWyl, $diaWyl)"/>
			</xsl:when>
			<xsl:when test="/*//title[@type='normalized-title' and @lang='tib']/comment()">
				<xsl:value-of select="translate(/*//title[@type='normalized-title']/comment(), $extWyl, $diaWyl)"/>
			</xsl:when>
			<xsl:when test="/*//title[@subtype='title-line']/comment()">
				<xsl:value-of select="translate(/*//title[@subtype='title-line']/comment(), $extWyl, $diaWyl)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="translate(/*//titlegrp//title[@lang='tib' and not(normalize-space(.)='')][1]/comment(), $extWyl, $diaWyl)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- parent_doc value example: kt/d/kt-d-cat.xml 
	<xsl:variable name="parent_doc"><xsl:value-of
	select="concat('../xml/',$collid,'/',$edid,'/',$collid,'-',$edid,'-cat.xml')"/></xsl:variable>-->
	<xsl:variable name="textbib_parent_cat"></xsl:variable>
	<xsl:variable name="master_doc"></xsl:variable>
	<xsl:variable name="vol_num"><xsl:value-of select="(/tibbibl/tibiddecl//tibid[@type='volume' and @system='number'])[1]/text()"/></xsl:variable>
	<xsl:variable name="vol_doc">
	</xsl:variable>
	<xsl:variable name="resouces_ct">
		<xsl:value-of select="count(/*//controlinfo/resources/xref[@rend='link']) +
			count(document($textbib_parent_cat)//controlinfo/resources/xref[@rend='link'])"/>
	</xsl:variable>
	<xsl:variable name="sigla"><xsl:value-of select="normalize-space(/*//tibid[@type='edition' and
			@system='sigla'][1]/text()[1])"/><xsl:if test="not(/*//tibid[@type='edition' and
			@system='sigla'][1])"><xsl:value-of select="normalize-space(/*//tibid[@type='collection' and
			@system='sigla'][1]/text()[1])"/></xsl:if></xsl:variable>
	<xsl:variable name="siglaCap"><xsl:value-of select="concat(translate(substring($sigla,1,1),$lc,$uc),substring($sigla,2))"/></xsl:variable>
	<xsl:variable name="txtnum"><xsl:value-of
			select="normalize-space(/*//tibid[@type='edition' and
			@system='sigla'][1]/tibid[@type='text' and @system='number']/text())"/><xsl:if test="not(/*//tibid[@type='edition' and
			@system='sigla'][1]/tibid[@type='text' and @system='number'])"><xsl:value-of
			select="normalize-space(/*//tibid[@type='collection' and
			@system='sigla'][1]/tibid[@type='text' and @system='number']/text())"/></xsl:if>
	</xsl:variable>
	<xsl:variable name="siglaid"><xsl:value-of select="$sigla"/>.<xsl:choose>
		<xsl:when test="contains($txtnum,'-')"><xsl:value-of select="$txtnum"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="format-number($txtnum,'###0')"/></xsl:otherwise>
	</xsl:choose></xsl:variable>
	<xsl:variable name="stpg">
		<xsl:value-of select="normalize-space(/tibbibl/physdecl[1]/pagination[1]/rs[1]/num[1]/text())"
		/>
	</xsl:variable> 
	<xsl:variable name="volid"><xsl:choose>
		<xsl:when test="count((/tibbibl[@level='text']/tibiddecl/tibid[@type='collection']/tibid[@type='edition'])[1]//tibid[@type='volume' and @system='number']) &gt; 1">
			<xsl:for-each select="(/tibbibl[@level='text']/tibiddecl/tibid[@type='collection']/tibid[@type='edition'])[1]//tibid[@type='volume' and @system='number']">
				<xsl:choose>
					<xsl:when test="position()=1"><xsl:value-of select="format-number(number(text()),'###')"/> - </xsl:when>
					<xsl:when test="position()=last()"><xsl:value-of select="format-number(number(text()),'###')"/></xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise><xsl:value-of select="format-number(number((/*//tibid[@type='volume' and
			@system='number'])[1]/text()),'###')"/></xsl:otherwise>
	</xsl:choose></xsl:variable>
	<xsl:variable name="firstPg"><xsl:value-of select="(/tibbibl[@level='text']/physdecl/pagination//rs[@n='start']/num[@type='page'])[1]/text()"/></xsl:variable>
	<xsl:variable name="sidesAdj"><xsl:choose>
		<xsl:when test="not(count(document($vol_doc)//extent[@class='sides-before-1a']/text())=0) and not(document($vol_doc)//extent[@class='sides-before-1a']/text()='')"><xsl:value-of select="document($vol_doc)//extent[@class='sides-before-1a']/text()"/></xsl:when>
		<xsl:otherwise>0</xsl:otherwise>
	</xsl:choose></xsl:variable>
	<xsl:variable name="imgNum"><xsl:choose>
		<xsl:when test="contains($firstPg,'a')"><xsl:value-of select="number(translate($firstPg,'ab','')) * 2 + number($sidesAdj) - 1"/></xsl:when>
		<xsl:when test="contains($firstPg,'b')"><xsl:value-of select="number(translate($firstPg,'ab','')) * 2 + number($sidesAdj)"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="number($firstPg) + number($sidesAdj)"/></xsl:otherwise>
	</xsl:choose></xsl:variable>
	<xsl:variable name="firstPgVol"><xsl:value-of select="format-number(number((/tibbibl[@level='text']/tibiddecl/tibid[@type='collection']/tibid[@type='edition'])[1]//tibid[@type='volume' and @system='number'][1]/text()[1]),'000')"/></xsl:variable>
	<xsl:variable name="firstPgImg"><xsl:value-of 
			select="document($textbib_parent_cat)//resources/xref[@type='page-img-loc' or @n='page-img-loc']/text()"/>v<xsl:value-of 
				select="$firstPgVol"/>/<xsl:value-of 
					select="concat($collid,'-',$edid,
					'-v',$firstPgVol,'-p',
					format-number(number($imgNum),'0000'))"/><xsl:choose><xsl:when test="$collid='ngb'">.gif</xsl:when>
						<xsl:otherwise>.png</xsl:otherwise></xsl:choose></xsl:variable>
	<xsl:template match="/">
		<xsl:variable name="titleLang"><xsl:choose><xsl:when test="contains($gentibtitle,'title')">eng</xsl:when><xsl:otherwise>tib</xsl:otherwise></xsl:choose></xsl:variable>
		<div class="results" id="{concat($sigla,'-',$txtid)}">
			<div id="tibbibl">
				<h2><span class="{$titleLang} bibltitle"><xsl:value-of select="$gentibtitle"/></span><xsl:text> </xsl:text>
					<span class="wyl bibltitle"><xsl:value-of select="$genwyltitle"/></span>
					(<span class="capitalize"><xsl:value-of select="$siglaid"/></span>) Catalog Record 
				</h2>
				
				<xsl:apply-templates />
				<xsl:for-each select=".//note">
					<div class="note">
						<h5>A note</h5>
						<xsl:apply-templates />
					</div>
				</xsl:for-each>
			</div>
			<xsl:call-template name="tibbiblJSON" />
		</div>
	</xsl:template>
	
	<!-- Creates links for various types of resources -->
	<xsl:template match="xref" mode="resourceLink">
		<xsl:choose>
			<xsl:when test="not($txtid='') and (@type='page-img-loc' or @n='page-img-loc') and @rend='link'">
				<a id="pageimglink" href="javascript:togglePageviewer();">View Page Images</a>
				<!--
				<a id="pageimglink" href="{$catreader}{$collid}/{$edid}/page/{substring-after($txtid,concat($edid,'-'))}" 
					onclick="return hs.htmlExpand(this, {$opnbrk}
						contentId: 'highslide-pgimg',
						objectType: 'ajax',    
						cacheAjax: false,
						wrapperClassName: 'highslide-white', 
						outlineType: 'rounded-white',    
						outlineWhileAnimating: true, 
						targetX: 'hspglink -950px', 
						targetY: 'hspglink 20px' {$clsbrk});" class="highslide">View Page Images</a>-->
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- Text Header Template-->
	<xsl:template match="tibbibl[@level='text']/head">
		<h2>
			<xsl:apply-templates/>
		</h2>
	</xsl:template>

	<!-- Templates for Tibiddecl -->
	<xsl:template match="tibiddecl">
		<h3 class="biblfull">Identification Information</h3>
		<ul class="bibldesc">
			<xsl:choose>
				<xsl:when test="@rend='master'">
					<xsl:call-template name="doMasterTibids"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="*[not(self::head) and not(self::note)]"/>
				</xsl:otherwise>
			</xsl:choose>
		</ul>
	</xsl:template>
	
	<xsl:template name="doMasterTibids">
		<li><span class="label">Collection Sigla</span> <xsl:value-of select=".//tibid[@type='collection' and @system='sigla']/text()[1]"/></li>
		<li><span class="label">Master ID</span> <span class="capitalize"><xsl:value-of select="normalize-space(.//tibid[@type='edition' and @system='sigla' and @n='master']/text()[1])"/></span>.<xsl:value-of 
			select="format-number(number(.//tibid[@type='edition' and @system='sigla' and @n='master']/tibid[@type='text' and @system='number']/text()[1]),'####')"/></li>
		<li><!--<span class="label">List of Versions</span>
			<table class="tibid-list" style="font-size: 80%;">
				<xsl:for-each select=".//tibid[@type='edition' and @system='letter' and not(@n='master')]">
					<tr>
						<td><xsl:value-of select="text()[1]"/></td>
						<td>
							<span class="capitalize"><xsl:value-of select="normalize-space(./tibid[@type='edition' and @system='sigla']/text()[1])"/></span>.<xsl:value-of 
								select="format-number(number(./tibid[@type='edition' and @system='sigla']/tibid[@type='text' and @system='number']/text()[1]),'####')"/>
						</td>
						<td>
							
						</td>
					</tr>
				</xsl:for-each>
				</table>-->
			<span class="label">List of Editions</span>
				<table class="master-edlist" cellpading="0" cellspacing="0">
					<tr>
						<th>Edition</th><th>ID</th><th>Volume</th><th>Text in Volume</th><th></th>
					</tr>
					<xsl:for-each select=".//tibid[@type='edition' and @system='letter' and not(@n='master')]">
						<xsl:variable name="thash">#cat=<xsl:value-of select="normalize-space(./tibid[@type='edition' and @system='sigla']/text()[1])"/>/<xsl:value-of 
							select="./tibid[@type='edition' and 
							@system='sigla']/tibid[@type='volume' and @system='number']/text()[1]"/></xsl:variable>
						<xsl:variable name="myed"><xsl:value-of select="normalize-space(./tibid[@type='edition' and @system='sigla']/text()[1])"/></xsl:variable>
						<xsl:variable name="mytnum"><xsl:value-of select="format-number(number(./tibid[@type='edition' and @system='sigla']/tibid[@type='text' and @system='number']/text()[1]),'####')"/></xsl:variable>
						<xsl:variable name="eddotnum"><xsl:value-of select="$myed"/>.<xsl:value-of 
							select="$mytnum"/></xsl:variable>
						<xsl:variable name="edvolnum"><xsl:value-of select="format-number(number(./tibid[@type='edition' and 
							@system='sigla']/tibid[@type='volume' and @system='number']/text()[1]),'####')"/></xsl:variable>
						<xsl:variable name="edtxtvolnum"><xsl:value-of select="format-number(number(./tibid[@type='edition' and 
							@system='sigla']/tibid[@type='volume' and @system='number']/tibid[@type='text' and 
							@system='number']/text()[1]),'####')"/></xsl:variable>
						<tr>
							<td>
								<strong><xsl:value-of select="text()[1]"/></strong>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="./altid[@n='filename']">
										<a href="{$thash}" class="capitalize"><xsl:value-of select="$eddotnum"/></a>
									</xsl:when>
									<xsl:otherwise>
										<span class="capitalize"><xsl:value-of select="$eddotnum"/></span>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:if test="not($edvolnum='NaN')"><xsl:value-of select="$edvolnum"/></xsl:if>
							</td>
							<td>
								<xsl:if test="not($edtxtvolnum='NaN')"><xsl:value-of select="$edtxtvolnum"/> </xsl:if>
							</td>
							<td>
								<xsl:if test="contains(document(concat('../xml/',/*//resources/xref[@n='parent-cat']/text()))//listBibl[@id='eds']/bibl[@n=$myed]/@rend,'pgimgs')">
									<a href="javascript:THLcat.showTextsPages('{$myed}','{$mytnum}');">View Scans</a>
								</xsl:if>
							</td>
						</tr>
					</xsl:for-each>
				</table>
		</li>
	</xsl:template>
	
	<xsl:template match="tibid[@type='collection' and @system='letter']">
		<li>
			<span class="label">Collection</span>
			<span class="tib">
				<xsl:value-of select="./altid[@lang='tib']"/>
			</span>
			<span class="sep"><xsl:text> </xsl:text></span>
			<span class="wyl">
				<xsl:value-of select="./altid[@lang='tib']/comment()"/>
			</span>
			<xsl:text> </xsl:text>
			<span class="biblfull eng"> (<xsl:value-of select="tibid[@type='collection' and @system='sigla']/text()"/>)</span>
		</li>
		<xsl:apply-templates select="tibid[@type='collection' and @system='sigla']"/>
	</xsl:template>
	
	<xsl:template match="tibid[@type='collection' and @system='sigla']">
		<xsl:choose>
			<xsl:when test="tibid[@type='edition' and @system='letter']">
				<xsl:apply-templates select="tibid"/>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<span class="label">Text ID</span>
					<xsl:value-of select="normalize-space(text()[1])"/>.<xsl:choose>
						<xsl:when test="contains($txtnum,'-')"><xsl:value-of select="$txtnum"/></xsl:when>
						<xsl:otherwise><xsl:value-of
							select="format-number(number(./tibid[@type='text' and @system='number'][1]),'###0')"/></xsl:otherwise>
					</xsl:choose>
				</li>
				<xsl:if test="./tibid[@type='volume' and @system='number']">
					<li>
						<span class="label">Volume<xsl:if test="count(./tibid[@type='volume' and @system='number'])
								&gt; 1">s</xsl:if></span>
						<xsl:apply-templates select="./tibid[@type='volume' and @system='number']"/>
					</li>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tibid[@type='edition' and @system='letter']">
		<xsl:choose>
			<xsl:when test="not(preceding-sibling::tibid[@type='edition' and @system='letter'])">
				<li>
					<span class="label">Edition</span>
					<xsl:if test="./altid[@lang='tib']/text()">
						<span class="tib">
							<xsl:value-of select="./altid[@lang='tib']"/>
						</span>
						<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
							<xsl:value-of select="./altid[@lang='tib']/comment()"/>
							<xsl:text> </xsl:text>
						</span>
					</xsl:if>
					<span class="biblfull eng"> <xsl:if test="./altid[@lang='tib']">(</xsl:if><xsl:value-of select="text()"/><xsl:if test="./altid[@lang='tib']">)</xsl:if></span>
				</li>
				<xsl:apply-templates select="tibid[@type='edition' and @system='sigla'][1]"/>
				<xsl:if test="following-sibling::tibid[@type='edition' and @system='letter'] and 0=1"> 
					<!-- 0=1 disables display of other editions for now until they can be extracted from master editions -->
					<li class="biblfull">
						<span class="label">Other Editions</span>
						<ul class="bibldesc">
							<xsl:for-each select="following-sibling::tibid[@type='edition' and
								@system='letter']">
								<xsl:variable name="label"><xsl:choose>
									<xsl:when test="./text()[1]='P'">Peking</xsl:when>
									<xsl:when test="./text()[1]='Toh'">Tohoku</xsl:when>
									<xsl:when test="./text()[1]='Dp'">Dharma Press</xsl:when>
									<xsl:otherwise><xsl:value-of select="text()[1]"/></xsl:otherwise>
								</xsl:choose></xsl:variable>
								<xsl:variable name="edSiglaVal"><xsl:choose><xsl:when test="tibid[@type='edition' and
									@system='sigla']/text()"><xsl:value-of select="normalize-space(tibid[@type='edition' and
										@system='sigla']/text())"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="text()[1]"/></xsl:otherwise>
								</xsl:choose></xsl:variable>
								<xsl:variable name="edSig"><xsl:value-of select="concat(translate(substring($edSiglaVal,1,1),$lc,$uc),substring($edSiglaVal,2))"/></xsl:variable>
								<xsl:variable name="txtnum" select="normalize-space(.//tibid[@type='text'
									and @system='number']/text())"/>
								<li>
									<span class="label">
										<xsl:value-of select="$label"/>
									</span>
									<xsl:value-of select="$edSig"/>
									<xsl:choose>
										<xsl:when test="contains($txtnum,'Not')">
											<xsl:text> –  </xsl:text>
										</xsl:when>
										<xsl:otherwise>.</xsl:otherwise>
									</xsl:choose>
									<xsl:value-of select="$txtnum"/>
									<xsl:if test="not(following-sibling::tibid[@type='edition' and
										@system='letter']) and
										local-name(parent::tibid/following-sibling::*[1])='note'">
										<xsl:apply-templates select="parent::tibid/following-sibling::*[1]"/>
									</xsl:if>
								</li>
							</xsl:for-each>
						</ul>
					</li>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tibid[@type='edition' and @system='sigla']">
		<xsl:variable name="edSiglaVal"><xsl:value-of select="normalize-space(text()[1])"/></xsl:variable>
		<xsl:variable name="edSig"><xsl:value-of select="concat(translate(substring($edSiglaVal,1,1),$lc,$uc),substring($edSiglaVal,2))"/></xsl:variable>
		
		<li>
			<span class="label">Text ID</span>
			<xsl:value-of select="$edSig"/>.<xsl:value-of
				select="format-number(number(./tibid[@type='text' and @system='number'][1]),'###0')"/>
		</li>
		<li>
			<span class="label">Volume<xsl:if test="count(./tibid[@type='volume' and @system='number'])
					&gt; 1">s</xsl:if></span>
			<xsl:apply-templates select="./tibid[@type='volume' and @system='number']"/>
		</li>
	</xsl:template>

	<xsl:template match="tibid[@type='volume' and @system='number']">
		<xsl:variable name="fullvolnum" select="format-number(number(text()[1]),'##0')"/>
		<xsl:element name="a">
			<xsl:attribute name="href">#cat=<xsl:value-of select="concat($edid,'/v',$fullvolnum)"/></xsl:attribute>
			<xsl:value-of select="$fullvolnum"/>
		</xsl:element>
		<span class="biblfull"> (<xsl:if test="altid"> <span class="tib">
				<xsl:value-of select="normalize-space(altid/text()[1])"/>
		</span><span class="wyl"><span class="sep" style="font-size: 110%;">, </span><xsl:value-of select="normalize-space(altid/comment()[1])"/></span><xsl:text>: 
		</xsl:text></xsl:if>text <xsl:value-of select="tibid[@type='text' and @system='number']"
			/>)</span>
		<xsl:if test="following-sibling::tibid[@type='volume' and @system='number']">, </xsl:if>
	</xsl:template>
	
	<xsl:template match="idno[@type='master']">
		<xsl:variable name="mid"><xsl:value-of select="substring-after(normalize-space(text()),concat($collid,'-'))"/></xsl:variable>
		<xsl:variable name="msig"><xsl:value-of select="substring-before($mid,'-')"/></xsl:variable>
		<xsl:variable name="mtid"><xsl:value-of select="format-number(number(substring-after($mid,'-')),'###0')"/></xsl:variable>
		<xsl:variable name="href">#cat=<xsl:value-of select="concat($msig,'/',$mtid)"/></xsl:variable>
		<xsl:variable name="lbl"><xsl:choose><xsl:when test="string(number(text()))='NaN'">Record</xsl:when><xsl:otherwise>Number</xsl:otherwise></xsl:choose></xsl:variable>
		<xsl:if test="not(normalize-space(text())='')"><li>
			<span class="label">Master Catalog <xsl:value-of select="$lbl"/></span>
			<xsl:choose>
				<xsl:when test="$lbl='Number'"><xsl:value-of select="format-number(number(normalize-space(.)),'####')" /></xsl:when>
				<xsl:otherwise><a href="{$href}" class="capitalize"><xsl:value-of select="concat($msig,'.',$mtid)"/></a></xsl:otherwise>
			</xsl:choose>
		</li></xsl:if>
	</xsl:template>

	<!-- Templates for publication decl -->
	<xsl:template match="tibbibl[@level='text']/pubdecl">
		<h3 class="biblfull">Publication Information</h3>
		<ul class="bibldesc">
			<xsl:apply-templates select="*[not(self::head) and not(self::note)]"/>
		</ul>
	</xsl:template>
	
	<!-- Templates for physdecl -->
	<xsl:template match="tibbibl[@level='text']/physdecl">
		<xsl:choose>
			<xsl:when test="@n='colophon'">
				<h3 class="biblfull">Colophon Contents</h3>
				<p>
					<xsl:apply-templates select="discussion[@n='colophon-contents']/* | 
							discussion[@n='colophon-contents']/text()"/>
					<span class="sep"><br/><br/></span>
					<span class="wyl">
						<xsl:value-of select="discussion[@n='colophon-contents']//comment()"/>
					</span>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<h3 class="biblfull">Physical Description</h3>
				<ul class="bibldesc">
					<xsl:apply-templates/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

	<xsl:template match="tibbibl[@level='text']/physdecl/pagination">
		<li id="txtpgn">
			<span class="label">Pagination</span>
			<xsl:apply-templates select="." mode="pagerange"/>
		</li>
	</xsl:template>

	<xsl:template match="extentdecl">
		<li>
			<span class="label">Total Sides</span>
			<xsl:choose>
				<xsl:when test="extent[@class='volume']">
					<xsl:value-of select="sum(extent[@class='volume'])"/>
					<span class="biblfull"> (<xsl:for-each select="extent[@class='volume']">
							<span class="label">Vol. <xsl:value-of select="@n"/>:</span>
							<xsl:value-of select="text()"/>
							<xsl:if test="following-sibling::extent[@class='volume']">, </xsl:if>
						</xsl:for-each>) </span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="extent[@class='total']"/>
				</xsl:otherwise>
			</xsl:choose>
		</li>
		<xsl:if test="extent[@class='differential']" />
			<!--<li class="biblfull">
				<span class="label">Page Differential: </span>
				<xsl:apply-templates select="extent[@class='differential']"/>
			</li>
		</xsl:if>-->
	</xsl:template>

	<xsl:template match="divdecl[@type='cle' or @type='chapter-level-elements']">
		<li>
			<span class="label">Number of Sections</span>
			<xsl:value-of select="divcount[@class='total']"/>
			<ul class="biblfull bibldesc">
				<li>
					<span class="label">Front</span>
					<xsl:value-of select="divcount[@class='front']"/>
				</li>
				<li>
					<span class="label">Body</span>
					<xsl:value-of select="divcount[@class='body']/text()"/>
				</li>
				<li>
					<span class="label">Back</span>
					<xsl:value-of select="divcount[@class='back']"/>
				</li>
			</ul>
		</li>
		<li class="biblfull">
			<span class="label">Section Types</span>
			<xsl:for-each select="divcount[@class='body']/name[@type='designation']/rs">
				<span class="{@lang}">
					<xsl:value-of select="text()"/><xsl:if test="@lang='tib' and (comment()='bam po' or comment()=concat('le',$apos,'u'))">།</xsl:if>
				</span>
				<xsl:if test="@lang='tib' and comment()">
					<span class="sep"><xsl:text> </xsl:text></span><span class="wyl"><xsl:value-of select="comment()"/><xsl:if test="comment()='bam po' or comment()=concat('le',$apos,'u')">/</xsl:if></span></xsl:if><xsl:if test="following-sibling::rs"><span style="font-size: 110%;"><xsl:text>; </xsl:text></span></xsl:if>
			</xsl:for-each>
		</li>
	</xsl:template>
	
<!-- already in cat-gentemps.xsl
	<xsl:template match="physfacet">
		<li class="biblfull">
			<span class="label capitalize">
				<xsl:value-of select="@type"/>
			</span>
			<span class="{@lang}">
				<xsl:apply-templates/>
			</span>
		</li>
	</xsl:template>
-->
	
	<!-- Templates for intelldecl -->
	<xsl:template match="tibbibl[@level='text']/intelldecl">
		<xsl:if test=".//*[string-length(text()) &gt; 0]">
			<h3 class="biblfull">Intellectual Description</h3>
			<ul class="bibldesc">
				<xsl:apply-templates />
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="doxography[@type='category' and @n='master']" mode="doxined">
		<xsl:for-each select="rs">
			<span class="tib"><xsl:value-of select="text()[1]"/> </span><xsl:text> </xsl:text> <xsl:if test="following-sibling::rs">: </xsl:if>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="doxography[@type='relation']">
		<xsl:variable name="val"><xsl:value-of select="translate(.,$uc,$lc)"/></xsl:variable>
		<li>
			<span class="label">Location in Canon</span>
			<xsl:choose>
				<xsl:when test="$val='k' or $val='kg'">
					<span class="tib">བཀའ་འགྱུར།</span>
					<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">bka’ ’gyur/</span>
				</xsl:when>
				<xsl:when test="$val='t' or $val='tg'">
					<span class="tib">བསྟན་འགྱུར།</span>
					<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">bstan ’gyur/</span>
				</xsl:when>
				<xsl:when test="@lang='tib'">
					<span class="tib">
						<xsl:value-of select="text()"/>
					</span>
					<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
						<xsl:value-of select="comment()"/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$val"/>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>

	<xsl:template match="doxography[@type='category']">
		<xsl:variable name="doxlang" select="@lang"/>
		<xsl:if test="not(normalize-space(text())='') or count(./rs) &gt; 0">
			<li>
				<span class="label">Category<xsl:choose>
					<xsl:when test="@subtype"> (<xsl:value-of select="@subtype" />)</xsl:when>
					<xsl:when test="@n"> (<xsl:value-of select="@n" />)</xsl:when>
				</xsl:choose></span>
				<span class="{$doxlang}">
					   <xsl:choose>
				        <xsl:when test="./rs">
				            <xsl:for-each select="./rs">
				                <xsl:value-of select="."/>
				                <xsl:if test="following-sibling::rs"><xsl:text> </xsl:text>:<xsl:text>
</xsl:text></xsl:if>					            </xsl:for-each>
				        </xsl:when>
				        <xsl:otherwise>
				            <xsl:value-of select="."/>
				        </xsl:otherwise>
				    </xsl:choose>
				      
				</span> 				<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
					<xsl:value-of select="comment()"/>
				</span>
			</li>
		</xsl:if>
	</xsl:template>

	<xsl:template match="doxography[@type='genre']">
		<xsl:variable name="doxlang" select="@lang"/>
		<xsl:variable name="val">
			<xsl:value-of select="."/>
		</xsl:variable>
		<li>
			<span class="label">Genre</span>
			<span class="{$doxlang}">
				<xsl:value-of select="text()"/>
			</span>
			<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
				<xsl:value-of select="comment()"/>
			</span>
		</li>
	</xsl:template>

	<!-- Templates for origination -->
	<xsl:template match="origination">
		<div class="biblfull">
			<h3>Provenance</h3>
			<ul class="bibldesc">
				<xsl:apply-templates/>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="origination/respdecl">
		<xsl:variable name="resptype"><xsl:value-of select="normalize-space(concat(translate(substring(@type,1,1),$lc,$uc),substring(@type,2)))"/></xsl:variable>
		<xsl:if test="not(normalize-space(./persName[1])='')">
		<h4 class="capitalize">
			<xsl:value-of select="$resptype"/><xsl:if test="count(persName) &gt; 1">s</xsl:if>
		</h4>
		<ul class="bibldesc">
			<xsl:if test="persName[contains(@type,'indian')]">
			<li>
				<xsl:choose>
					<xsl:when test="count(persName[contains(@type,'indian')]) &gt; 1">
						<span class="label">Indian <xsl:value-of select="$resptype"/>s</span>
						<ul class="catlist">
							<xsl:for-each select="persName[contains(@type,'indian')]">
								<xsl:variable name="classval"><xsl:value-of select="@lang"/><xsl:if test="@lang='san'">-show</xsl:if></xsl:variable>
								<li>
									<span class="{$classval}">
										<xsl:value-of select="text()"/>
									</span>
									<xsl:if test="@lang='tib'">
										<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
											<xsl:value-of select="comment()"/>
										</span>
									</xsl:if>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:when test="count(persName[contains(@type,'indian')]) = 1">
						<xsl:variable name="classval"><xsl:value-of select="persName[contains(@type,'indian')]/@lang"/><xsl:if test="persName[contains(@type,'indian')]/@lang='san'">-show</xsl:if></xsl:variable>
						<span class="label">Indian <xsl:value-of select="$resptype"/></span>
						<span class="{$classval}">
							<xsl:value-of select="persName[contains(@type,'indian')]/text()"/>
						</span>
						<xsl:if test="contains($classval,'tib')">
							<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
								<xsl:value-of select="persName[contains(@type,'indian')]/comment()"/>
							</span>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</li>
			</xsl:if>
			<!-- not Indian or Tibetan scholars -->
			<xsl:if test="persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))]">
				<li>
					<xsl:choose>
						<xsl:when test="count(persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))]) &gt; 1">
							<span class="label"><xsl:value-of select="persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))][1]/@type"/>
							<xsl:text> </xsl:text>
							<xsl:if test="not(translate($resptype,$uc,$lc)=normalize-space(translate(persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))][1]/@type,$uc,$lc)))"><xsl:value-of select="$resptype"/>s</xsl:if></span>
							<ul class="catlist">
								<xsl:for-each select="persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))]">
									<xsl:variable name="classval"><xsl:value-of select="@lang"/><xsl:if test="@lang='san'">-show</xsl:if></xsl:variable>
									<li>
										<span class="{$classval}">
											<xsl:value-of select="text()"/>
										</span>
										<xsl:if test="@lang='tib'">
											<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
												<xsl:value-of select="comment()"/>
											</span>
										</xsl:if>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:when>
						<xsl:when test="count(persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))]) = 1">
							<xsl:variable name="classval"><xsl:value-of select="persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))]/@lang"/><xsl:if 
								test="persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))]/@lang='san'">-show</xsl:if></xsl:variable>
							<span class="label"><xsl:value-of select="persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))]/@type"/>
							<xsl:text> </xsl:text>
							<xsl:if test="not(translate($resptype,$uc,$lc)=normalize-space(translate(persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))][1]/@type,$uc,$lc)))"><xsl:value-of select="$resptype"/>s</xsl:if></span>
							<span class="{$classval}">
								<xsl:value-of select="persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))]/text()"/>
							</span>
							<xsl:if test="contains($classval,'tib')">
								<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
									<xsl:value-of select="persName[not(contains(@type,'indian')) and not(contains(@type,'tibetan'))]/comment()"/>
								</span>
							</xsl:if>
						</xsl:when>
					</xsl:choose>
				</li>
			</xsl:if>
			<xsl:if test="persName[contains(@type,'tibetan')]">
			<li>
				<xsl:choose>
					<xsl:when test="count(persName[contains(@type,'tibetan')]) &gt; 1">
						<span class="label">Tibetan <xsl:value-of select="$resptype"/>s</span>
						<ul class="catlist">
							<xsl:for-each select="persName[contains(@type,'tibetan')]">
								<xsl:variable name="classval"><xsl:value-of select="@lang"/><xsl:if test="@lang='san'">-show</xsl:if></xsl:variable>
								<li>
									<span class="{$classval}">
										<xsl:value-of select="text()"/>
									</span>
									<xsl:if test="$classval='tib'">
										<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
											<xsl:value-of select="comment()"/>
										</span>
									</xsl:if>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:when test="count(persName[contains(@type,'tibetan')]) = 1">
						<xsl:variable name="classval"><xsl:value-of select="persName[contains(@type,'tibetan')]/@lang"/><xsl:if test="persName[contains(@type,'tibetan')]/@lang='san'">-show</xsl:if></xsl:variable>
						<span class="label">Tibetan <xsl:value-of select="$resptype"/></span>
						<span class="{$classval}">
							<xsl:value-of select="persName[contains(@type,'tibetan')]/text()"/>
						</span>
						<xsl:if test="$classval='tib'">
							<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
								<xsl:value-of select="persName[contains(@type,'tibetan')]/comment()"/>
							</span>
						</xsl:if>
					</xsl:when>
				</xsl:choose>
			</li>
			</xsl:if>
			<xsl:apply-templates select="date | placeName | discussion | source"/>
		</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="date">
		<li>
			<span class="label">Date</span>
			<xsl:choose>
				<xsl:when test="@lang='tib'">
					<span class="tib">
						<xsl:value-of select="text()"/>
					</span>
					<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
						<xsl:value-of select="comment()"/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<span class="eng">
						<xsl:value-of select="text()"/>
					</span>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>

	<xsl:template match="placeName">
		<li>
			<span class="label">Place</span>
			<xsl:choose>
				<xsl:when test="@lang='tib'">
					<span class="tib">
						<xsl:value-of select="text()"/>
					</span>
					<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
						<xsl:value-of select="comment()"/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<span class="eng">
						<xsl:value-of select="text()"/>
					</span>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>

	<xsl:template match="source">
		<li>
			<span class="label">Source</span>
			<xsl:apply-templates select="." mode="pagerange"/>
			<xsl:if test="following-sibling::note"><xsl:text> </xsl:text><xsl:apply-templates select="following-sibling::note"/></xsl:if>
		</li>
	</xsl:template>
	
	<!-- Templates for titlegrp -->
	<xsl:template match="titlegrp">
		<h3 class="biblfull">Title Information</h3>
		<ul class="bibldesc">
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="tibbibl[@level='text']/titlegrp/titledecl[not(.//source/rs[@type='crossref'])]">
		<h4>Normalized Title</h4>
		<ul type="bibldesc">
			<li>
				<xsl:apply-templates select="title[@type='normalized-title' and @lang='tib']"/>
				<xsl:for-each select="title[@type='normalized-title' and @lang='tib']/following-sibling::source[1]"><xsl:call-template name="doSource"/></xsl:for-each>
			</li>
			<xsl:if test="title[@type='normalized-title' and @lang='eng'] and string-length(normalize-space((title[@type='normalized-title' and @lang='eng'])[1])) &gt; 0">
				<li class="eng">
					<xsl:value-of select="title[@type='normalized-title' and @lang='eng']"/>
					<xsl:for-each select="title[@type='normalized-title' and @lang='eng']/following-sibling::source[1]"><xsl:call-template name="doSource"/></xsl:for-each>
				</li>
			</xsl:if>
			<xsl:if test="title[@type='normalized-title' and @lang='san'] and string-length(normalize-space((title[@type='normalized-title' and @lang='san'])[1])) &gt; 0">
				<li class="san">
					<xsl:value-of select="title[@type='normalized-title' and @lang='san']"/>
					<xsl:for-each select="title[@type='normalized-title' and @lang='san']/following-sibling::source[1]"><xsl:call-template name="doSource"/></xsl:for-each>
				</li>
			</xsl:if>
		</ul>
	</xsl:template>
	
	
	<xsl:template match="tibbibl[@level='text']/titlegrp/titledecl[.//source/rs[@type='crossref']]">
		<xsl:variable name="cr" select="normalize-space(.//source/rs[@type='crossref']/text()[1])"/>
		<xsl:variable name="cred" select="normalize-space(translate(substring-before($cr,'.'),$uc,$lc))"/>
		<xsl:variable name="crnm" select="format-number(number(substring-after($cr,'.')),'0000')"/>
		<xsl:variable name="crfold" select="substring($crnm,1,1)"/>
		<xsl:variable name="crdoc" select="concat('../xml/',$collid,'/',$cred,'/',$crfold,'/',$collid,'-',$cred,'-',$crnm,'-bib.xml')" />
		<h4>Normalized Title</h4>
		<ul type="bibldesc">
			<li>
				<xsl:apply-templates select="document($crdoc)//titlegrp/titledecl[@n='text']/title[@lang='tib']" /> 
			</li>
			<xsl:if test="not(normalize-space(document($crdoc)//titlegrp/titledecl[@n='text']/title[@lang='eng'][1]/text[1])='')">
				<li>
					<xsl:apply-templates select="document($crdoc)//titlegrp/titledecl[@n='text']/title[@lang='eng']" />
				</li>
			</xsl:if>
			<li>
				<span class="label">Source</span>
				<xsl:value-of select="$cr"/>
			</li>
		</ul>
		<xsl:if test="./title[@type='edition-title']">
			<h4>Edition Title</h4>
			<ul type="bibldesc">
				<li>
					<xsl:apply-templates select="./title[@type='edition-title'] | ./title[@type='edition-title']/following-sibling::source | ./title[@type='edition-title']/following-sibling::note"/>
				</li>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="titleinfo">
		<div class="biblfull">
			<h4>Title Variants</h4>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="titleinfo/titlediv[@type='front' or @type='back']">
		<h5 class="capitalize">
			<xsl:value-of select="translate(@subtype,'-',' ')"/>
		</h5>
		<ul type="bibldesc">
			<li>
				<xsl:apply-templates select="titledecl/title[@lang='tib']"/><xsl:if test="not(contains(titledecl/title[@lang='eng']/text(),'Not')) and pagination/text()">
					(<xsl:apply-templates select="pagination" mode="pagerange"/>)</xsl:if><xsl:apply-templates select="titledecl/note"/>
			</li>
			<li>
				<span class="eng">
					<xsl:value-of select="titledecl/title[@lang='eng']"/>
				</span>
			</li>
			
		</ul>
	</xsl:template>

	<xsl:template match="titleinfo/titlediv[@type='body']/titlelist">
		<div class="biblfull">
			<xsl:if test="not(preceding-sibling::titlelist)">
				<h5>Text Titles Given in Chapters</h5>
			</xsl:if>
			<ul type="bibldesc">
				<li>
					<xsl:apply-templates select="titledecl/title[@lang='tib']"/>
				</li>
				<li>
					<span class="eng">
						<xsl:value-of select="titledecl/title[@lang='eng']"/>
					</span>
				</li>
				<li>(Chapters: <xsl:apply-templates select="titleitem"/>)</li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="titleitem">
		<strong>
			<xsl:value-of select="designation/text()"/>
		</strong><xsl:if test="pagination/text()"> - <xsl:apply-templates select="pagination" mode="pagerange"/></xsl:if><xsl:if
			test="following-sibling::titleitem">; </xsl:if></xsl:template>

	<xsl:template match="titleinfo/titlediv[@type='nontibet']">
		<h5>Non-Tibetan Title</h5>
		<ul type="bibldesc">
			<xsl:if test="titledecl/title[@lang='tib']">
				<li>
					<xsl:apply-templates select="titledecl/title[@lang='tib']"/> 
					<xsl:if test="not(contains(titledecl/title[@lang='eng']/text(),'Not')) and pagination/text()">(<xsl:apply-templates 
						select="pagination" mode="pagerange"/>)</xsl:if><xsl:apply-templates select="titledecl/note"/>
				</li>
			</xsl:if>
			<xsl:if test="titledecl/title[@lang='eng']">
				<li>
					<span class="eng"><xsl:value-of select="titledecl/title[@lang='eng']"/></span><xsl:if 
						test="not(titledecl/title[@lang='eng']/preceding-sibling::title[@lang='tib'])"><xsl:apply-templates select="titledecl/title[@lang='eng']/following-sibling::note"/></xsl:if>
				</li>
			</xsl:if>
			<xsl:if test="not(contains(titledecl/title[@lang='eng']/text(),'No')) and 
				not(normalize-space(titledecl/discussion[@type='original-language']/text())='')">
				<li><span class="label small">Original Language</span> <span
						class="{titledecl/discussion[@type='original-language']/@lang}">
						<xsl:value-of select="titledecl/discussion[@type='original-language']/text()"/>
					</span>
					<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
						<xsl:value-of select="titledecl/discussion[@type='original-language']/comment()"/>
					</span>
				</li>
			</xsl:if>
			<xsl:if test="titledecl/title[@type='normalized']">
				<li>
					<span class="label small">Normalized</span><xsl:if test="count(titledecl/title[@type='normalized']) &gt; 1">
						<xsl:text disable-output-escaping="yes"><![CDATA[<div style="display: block; padding-left: 24px;">]]></xsl:text>
					</xsl:if>
					<xsl:for-each select="titledecl/title[@type='normalized']"><xsl:value-of 
						select="."/><xsl:if test="following-sibling::title[@type='normalized']"><br/></xsl:if></xsl:for-each>
					<xsl:if test="count(titledecl/title[@type='normalized']) &gt; 1">
						<xsl:text disable-output-escaping="yes"><![CDATA[</div>]]></xsl:text>
					</xsl:if>
				</li>
			</xsl:if>
		</ul>
	</xsl:template>
	
	<xsl:template match="titleinfo/titlediv[@type and not(@type='front' or @type='back' or @type='body' or @type='nontibet')]">
		<h5 class="capitalize">
			<xsl:value-of select="@type"/>
		</h5>
		<ul type="bibldesc">
			<li>
				<xsl:apply-templates select="titledecl/title[@lang='tib']"/>
			</li>
			<li>
				<span class="eng">
					<xsl:value-of select="titledecl/title[@lang='eng']"/>
				</span>
			</li>
			<xsl:if test="not(contains(titledecl/title[@lang='eng']/text(),'Not')) and pagination/text()">
				<li>(<xsl:apply-templates select="pagination" mode="pagerange"/>)</li>
			</xsl:if>
		</ul>
	</xsl:template>
	
	<!-- General Templates -->
	<xsl:template match="/*/*/head | /*/titlegrp//head"/>
	
	<xsl:template name="doSource">[hey I'm a source]</xsl:template>
	
	<xsl:template name="tibbiblJSON">{ "this_is":"tibbiblJSON" }</xsl:template>
</xsl:stylesheet>
