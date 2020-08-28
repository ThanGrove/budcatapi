<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
	
	<!-- Metadata Styles -->
	<xsl:template match="controlinfo">
		<div id="metadata">
			<h3 class="biblfull">Metadata</h3>
			<ul class="bibldesc">
				<xsl:apply-templates />
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template match="sysid">
		<li><span class="label">File Name</span> <xsl:value-of select="."/></li>
	</xsl:template>
	
	<xsl:template match="controlinfo/date">
		<li><span class="label">Date Cataloged</span> 
			<xsl:call-template name="formatDate">
					<xsl:with-param name="date" select="text()"/>
			</xsl:call-template>
		</li>
	</xsl:template>
	
	<xsl:template match="respStmt">
		<xsl:variable name="dt">
			<xsl:choose>
				<xsl:when test="name/date">
					<xsl:value-of select="name/date/text()"/>
				</xsl:when>
				<xsl:when test="preceding-sibling::date">
					<xsl:value-of select="preceding-sibling::date/text()"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="./name[not(normalize-space(text())='')]">
			<li>
				<span class="label"><xsl:apply-templates select="resp"/></span>
				<xsl:for-each select="./name"><xsl:apply-templates select="."/><xsl:if test="following-sibling::name"><xsl:text>, </xsl:text></xsl:if></xsl:for-each>
				(<xsl:call-template name="formatDate">
					<xsl:with-param name="date" select="$dt"/>
				</xsl:call-template>)
			</li>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="respStmt/name | orgName">
		<xsl:variable name="nm" select="normalize-space(translate(text(),'/',''))"/>
		<xsl:variable name="fullnm"><xsl:if test="string-length($nm) &lt; 5 
			or (string-length($nm)=7 and substring($nm,1,3)='per')"><xsl:value-of 
				select="normalize-space(document($respdoc)//item[./abbr/@id=$nm]/persName/text())"/></xsl:if></xsl:variable><xsl:choose>
			<xsl:when test="@reg"><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of 
						select="concat($thdl_participants_url,@key)"/></xsl:attribute><xsl:apply-templates /></xsl:element></xsl:when>
			<xsl:when test="string-length(normalize-space($fullnm)) &gt; 0"><xsl:value-of 
				select="$fullnm"/></xsl:when>
			<xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
		</xsl:choose><xsl:if test="parent::respStmt and following-sibling::name"><xsl:text>, </xsl:text></xsl:if></xsl:template>
	
	<xsl:template match="address">
		<xsl:if test="@rend='parens'">(</xsl:if><xsl:for-each select="addrLine"><xsl:apply-templates/><xsl:if test="following-sibling::addrLine"><xsl:text>, </xsl:text></xsl:if></xsl:for-each><xsl:if test="@rend='parens'">)</xsl:if>
	</xsl:template>
	
	<xsl:template match="revisionDesc">
		<xsl:for-each select="change">
			<xsl:apply-templates select="respStmt"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="resources" />
	<!-- end of Metadata templates -->
	
	<xsl:template match="idno">
		<xsl:if test="not(@type='file')">
			<li>
				<span class="label capitalize"><xsl:value-of select="@type"/></span>
				<xsl:apply-templates />
			</li>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="extent[@class='differential']"/>
	
	<xsl:template match="pubPlace">
		<li>
			<span class="label capitalize">Place of Publication</span>
			<xsl:apply-templates />
		</li>
	</xsl:template>
	
	<xsl:template match="publisher">
		<li>
			<span class="label capitalize">Publisher</span>
			<xsl:apply-templates />
		</li>
	</xsl:template>
				
	<xsl:template match="date">
		<li>
			<span class="label capitalize">Date</span>
			<xsl:apply-templates />
		</li>
	</xsl:template>
				
	<xsl:template match="publicationStmt/respStmt">
		<li>
			<span class="label capitalize"><xsl:value-of select="resp"/></span>
			<xsl:apply-templates select="name"/>
		</li>
	</xsl:template>
	
	<xsl:template match="publicationStmt/idno[@type='sourcefile']">
		<xsl:if test="string-length(normalize-space(./text())) &gt; 0">
			<li>
				<span class="label capitalize">Source File</span>
				<xsl:apply-templates select="text()"/> [<xsl:value-of select="string-length(normalize-space(./text()))"/>]
			</li>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="publicationStmt/availability">
		<xsl:if test="not(normalize-space(text())='')">
			<li>
				<span class="label capitalize">Availability</span>
				<xsl:apply-templates select="text()"/>
			</li>
		</xsl:if>
	</xsl:template>
	
	<!-- Templates for sections -->
	<xsl:template match="sections">
		<xsl:param name="sectionmode" />
		
		<div id="text-toc" class="biblfull">
		<xsl:choose>
			<xsl:when test="count(/*//tibbibl) &gt; 2000"> <!-- uped to 2000 to take out this option as it wasn't working -->
				<xsl:variable name="url">/<xsl:value-of select="$collid"/>/<xsl:value-of select="$edid"/>/<xsl:value-of select="txtid"/>/texttoc</xsl:variable>
				<p style="padding-left: 24px;"><img src="/global/images/ajax-loader.gif" class="loadimg" /><em> Loading Table of Contents...</em></p>
				<xsl:text disable-output-escaping="yes"><![CDATA[
					<script type="text/javascript">
						loadLargeTOC();
					</script>
				]]></xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<!-- if it's in a concat container, it's master catalog so insert name of edition that TOC comes from -->
				<h3><xsl:if test="ancestor::div[@n='tibbibls' and @type='container']"><xsl:value-of 
					select="ancestor::div[1]/tibbibl[@level='text']/tibiddecl/tibid[@type='collection']/tibid[@type='edition' and @system='letter'][1]/text()"/><xsl:text> </xsl:text></xsl:if>Table of Contents</h3>
				<ul class="bibldesc">
					<xsl:apply-templates/>
				</ul>
				<xsl:for-each select=".//note">
					<xsl:call-template name="doNoteContent"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="tibbibl[@level='text']/sections/tibanal">
		<h4>
			<xsl:choose>
				<xsl:when test="@n='1'">Front</xsl:when>
				<xsl:when test="@n='2'">Body</xsl:when>
				<xsl:when test="@n='3'">Back</xsl:when>
			</xsl:choose>
		</h4>
		<xsl:choose>
			<xsl:when test="tibbibl[@level='chapgroup']">
				<xsl:apply-templates select="tibbibl[@level='chapgroup']"/>
			</xsl:when>
			<xsl:otherwise>
				<table border="0" cellpadding="0" cellspacing="5">
					<tr>
						<xsl:if test="count(preceding-sibling::tibanal)=1">
							<th width="8%">Chapter</th>
						</xsl:if>
						<th width="70%">Name</th>
						<th width="7%">ID</th>
						<th width="15%">Pagination</th>
					</tr>
					<xsl:choose>
						<xsl:when test="tibbibl/@n='a0'"><tr><td colspan="4"><em>No Front Sections</em></td></tr></xsl:when>
						<xsl:when test="tibbibl/@n='c0'"><tr><td colspan="4"><em>No Back Sections</em></td></tr></xsl:when>
						<xsl:otherwise><xsl:apply-templates select="tibbibl"/></xsl:otherwise>
					</xsl:choose>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tibbibl[@level='chapgroup' and tibanal/tibbibl]">
		<h5 class="chapgroup">
			<xsl:value-of select="head"/>: <xsl:apply-templates select="titledecl/title[@lang='tib']"/>
			<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
				<xsl:call-template name="diacritics"><xsl:with-param name="txt"><xsl:value-of select="titledecl/title[@lang='tib']/comment()"/></xsl:with-param></xsl:call-template>
			</span>
			<span class="refinfo">(<xsl:value-of select=".//tibid[@type='chapgroup' and @system='number']"/>, <xsl:apply-templates select="physdecl/pagination" mode="pagerange"/>)</span>
		</h5>
		<table border="0" cellpadding="0" cellspacing="5" id="text-toc">
			<tr>
				<xsl:if test="count(ancestor::tibanal/preceding-sibling::tibanal)=1">
					<th width="8%">Chapter</th>
				</xsl:if>
				<th width="70%">Name</th>
				<th width="7%">ID</th>
				<th width="15%">Pagination</th>
			</tr>
			<xsl:apply-templates select="tibanal/tibbibl"/>
		</table>
	</xsl:template>
	
	<xsl:template match="tibbibl[@level='chapgroup' and not(tibanal/tibbibl)]">
		<h5 class="chapgroup-nochap">
			<table border="0" cellpadding="0" cellspacing="5" id="text-toc">
				<td width="15%"><xsl:value-of select="head"/></td> 
				<td width="60%"> 
					<xsl:apply-templates select="titledecl/title[@lang='tib']"/>
				</td>
				<td width="10%"><xsl:value-of select=".//tibid[@type='chapgroup' and @system='number']"/></td>
				<td width="15%" class="sect-pg"><xsl:apply-templates select="physdecl/pagination" mode="pagerange"/></td>
			</table>
		</h5>
	</xsl:template>
	
	<xsl:template match="tibanal/tibbibl[@level='chapter']">
		<xsl:variable name="chaphead">
			<xsl:value-of select="normalize-space(head/text()[1])"/>
		</xsl:variable>
		<tr id="{@n}">
			<xsl:if test="count(ancestor::tibanal/preceding-sibling::tibanal)=1">
				<td valign="top" align="center" class="chapnum">
					<xsl:choose>
						<xsl:when test="contains($chaphead,'Chapter')">
							<xsl:value-of select="substring-after($chaphead,'Chapter')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$chaphead"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:if>
			<td valign="top" class="chap-title">
				<xsl:apply-templates select="titledecl/title[@lang='tib']"/>
				<!--<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
					<xsl:call-template name="diacritics"><xsl:with-param name="txt"><xsl:value-of select="titledecl/title[@lang='tib']/comment()"/></xsl:with-param></xsl:call-template>
				</span>-->
				<span class="eng">
					<xsl:apply-templates select="titledecl/title[@lang='eng']"/>
				</span>
				<xsl:if test="titledecl/source/text()">
					<span class="title-source"><xsl:text> </xsl:text>
						<xsl:choose>
					<xsl:when test="$edid='master'">
						<xsl:variable name="tid"><xsl:value-of select="translate(substring-before(substring-after(ancestor::tibbibl[@level='text']/@id,'-'),'-bib'),'-','/')"/></xsl:variable>
						(<xsl:apply-templates select="titledecl/source" mode="pagerange">
							<xsl:with-param name="master">yes</xsl:with-param>
							<xsl:with-param name="edid"><xsl:value-of select="$tid"/></xsl:with-param></xsl:apply-templates>)
					</xsl:when>
					<xsl:otherwise>
						(<xsl:apply-templates select="titledecl/source" mode="pagerange"/>)
					</xsl:otherwise>
				</xsl:choose>
				</span>
				</xsl:if>
				<xsl:if test="not(titledecl) and head[not(normalize-space(text())='')]">
					<span class="eng"><xsl:apply-templates select="head/* | head/text()"/></span>
				</xsl:if>
			</td>
			<td valign="top" class="chap-id">
				<xsl:apply-templates select="tibiddecl/tibid"/>
			</td>
			<td valign="top" class="chap-pg">
				<xsl:choose>
					<xsl:when test="$edid='master'">
						<xsl:variable name="tid"><xsl:value-of select="translate(substring-before(substring-after(ancestor::tibbibl[@level='text']/@id,'-'),'-bib'),'-','/')"/></xsl:variable>
						<xsl:apply-templates select="physdecl/pagination" mode="pagerange">
							<xsl:with-param name="master">yes</xsl:with-param>
							<xsl:with-param name="edid"><xsl:value-of select="$tid"/></xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="physdecl/pagination" mode="pagerange"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="physdecl/note"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="discussion[@type='homage-obj']">
		<li class="biblfull">
			<span class="label">Object of Homage</span>
			<span class="tib">
				<xsl:value-of select="text()"/>
			</span>
			<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
				<xsl:call-template name="diacritics"><xsl:with-param name="txt"><xsl:value-of select="./comment()"/></xsl:with-param></xsl:call-template>
			</span>
			<xsl:if test="rs[@n='source']"> (<xsl:apply-templates select="rs[@n='source']"/>) </xsl:if>
			<xsl:if test="source"><xsl:apply-templates select="source"/></xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match="source"><xsl:choose>
		<xsl:when test="normalize-space(.)=''" />
		<xsl:when test="contains(@rend,'own-line')"><br/><strong>Souce: </strong><xsl:value-of select="normalize-space(text()[1])"/><xsl:if test="rs[@type='pagination']"><xsl:text> </xsl:text><xsl:apply-templates select="rs[@type='pagination'][1]"/><xsl:if 
			test="count(rs[@type='pagination'])=2">-<xsl:apply-templates select="rs[@type='pagination'][2]"/></xsl:if></xsl:if></xsl:when>
		<xsl:otherwise><span class="eng">(<xsl:value-of select="normalize-space(text()[1])"/><xsl:if test="rs[@type='pagination']"><xsl:text> </xsl:text><xsl:apply-templates select="rs[@type='pagination'][1]"/><xsl:if 
			test="count(rs[@type='pagination'])=2">-<xsl:apply-templates select="rs[@type='pagination'][2]"/></xsl:if></xsl:if>)</span></xsl:otherwise>
	</xsl:choose></xsl:template>
		
	<xsl:template match="discussion[not(@rend='popup') and not(normalize-space(.)='') and not(@type='homage-obj')]">
		<li class="biblfull">
			<span class="label capitalize">
				<xsl:choose>
					<xsl:when test="@type='intra-canonical-relation'">Intra-canonical Relation</xsl:when>
					<xsl:when test="@type='homage-obj'">Object of Homage</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="translate(@type,'-',' ')"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="(@type='colophon' or @n='colophon') and bibl/num[@type='pagination']/text()">
					<xsl:text> </xsl:text><span style="font-size: 90%; font-weight: normal;">
					(<xsl:apply-templates select="bibl/num[@type='pagination']" mode="pagerange"/>)</span>
				</xsl:if>
			</span>
			<xsl:element name="span">
				<xsl:if test="not(@type='colophon' or @n='colophon')"><xsl:attribute name="class" select="@lang"/></xsl:if>
				<xsl:apply-templates/>
			</xsl:element>
			<xsl:if test="(./@lang='tib' or ./p/@lang='tib') and .//comment()">
				<span class="sep"><xsl:text> </xsl:text></span><span class="wyl"><xsl:call-template name="diacritics"><xsl:with-param name="txt"><xsl:value-of select=".//comment()"/></xsl:with-param></xsl:call-template></span>
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match="discussion[@type='colophon']/bibl"/>

	<!-- This was: <xsl:template match="discussion[@rend='choice']" mode="volume"> not sure why -->
	<xsl:template match="discussion[not(@rend='info')]" mode="volume"><xsl:apply-templates select="."/></xsl:template>
	
	<xsl:template match="discussion[@rend='popup']">
		<xsl:if test="not(string-length(normalize-space(.))=0)">
			<li class="nocolon">
				<xsl:call-template name="discussionLink"/>
			</li>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="discussionLink">
		<xsl:param name="lnkText" />
		<xsl:variable name="myid"><xsl:choose><xsl:when test="@id and not(@id='')"><xsl:value-of select="@id"/></xsl:when><xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise></xsl:choose></xsl:variable>
		<xsl:variable name="linktxt">
			<xsl:choose>
				<xsl:when test="not($lnkText='')"><xsl:value-of select="$lnkText"/></xsl:when>
				<xsl:when test="rs[@type='header']/text()"><xsl:value-of select="rs[@type='header']/text()"/></xsl:when>
				<xsl:when test="@n"><xsl:value-of select="@n"/></xsl:when>
				<xsl:when test="@type"><xsl:value-of select="translate(@type,'-',' ')"/></xsl:when>
				<xsl:otherwise>discussion</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<ul class="bibldesc">
			<li>
				<a id="{$myid}" href="#" class="jqm-link icon-info">
					<span class="capitalize">
						<xsl:value-of select="$linktxt"/>
					</span>
				</a>
			</li>
		</ul>
		<div id="{$myid}-info" class="jqmWindow">
			<div class="closebtn"><a href="#">Close</a></div>
			<div class="conx-content">
				<h2><xsl:value-of select="$linktxt"/></h2>
				<xsl:apply-templates />
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="genreform | physfacet | dimensions">
		<xsl:if test="text() or *">
			<li>
			<span class="label capitalize"><xsl:value-of select="@type"/></span>
			<xsl:choose>
				<xsl:when test="@lang='tib'">
					<span class="tib"><xsl:value-of select="normalize-space(text())"/></span>
					<xsl:if test="./comment()">
						<span class="sep"><xsl:text> </xsl:text></span><span class="wyl"><xsl:call-template name="diacritics"><xsl:with-param name="txt"><xsl:value-of select="./comment()"/></xsl:with-param></xsl:call-template></span>
					</xsl:if>
				</xsl:when>
				<xsl:when test="self::physfacet and *">
					<xsl:apply-templates />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(text())"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="translate(@type,$uc,$lc)='script' and normalize-space(text())='དབུ་ཅན།'">
			<xsl:text> </xsl:text><span class="eng">block script</span>
			</xsl:if>
		</li>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="*" mode="pagerange">
		<xsl:param name="master"/>
		<xsl:param name="edid"/>
		<xsl:param name="myedsig"><xsl:choose>
			<xsl:when test="contains($edid,'/')"><xsl:value-of select="substring-before($edid,'/')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$edid"/></xsl:otherwise>
		</xsl:choose></xsl:param><xsl:choose>
			<!-- For NGB Texts 
			<xsl:when test="$collid='old-ngb'">
				<xsl:choose>
					<xsl:when test="rs[@type='pagination'] and $master='yes' and not(contains(/*/@id,'dg')) and not(contains($edid,'dg'))">
						<a class="{substring-before($edid,'/')}-pglink" href="javascript:showMasterPage('{$edid}','{./rs[@type='pagination'][1]/num[1]/text()}');" title="View these pages">
						<xsl:apply-templates select="rs[@type='pagination'][1]"/><xsl:if test="rs[@type='pagination' and @n='end']">-<xsl:apply-templates select="rs[@type='pagination' and @n='end']"/></xsl:if>
						</a></xsl:when>
					<xsl:when test="rs[@type='pagination'] and (contains(/*/@id,'dg') or contains($edid,'dg'))">
						<xsl:apply-templates select="rs[@type='pagination'][1]"/><xsl:if test="rs[@type='pagination' and @n='end']">-<xsl:apply-templates select="rs[@type='pagination' and @n='end']"/></xsl:if></xsl:when>
					<xsl:when test="rs[@type='pagination']">
						<a href="javascript:showPage('{./rs[@type='pagination'][1]/num[1]/text()}');" title="View these pages"><xsl:apply-templates select="rs[@type='pagination'][1]"/><xsl:if test="rs[@type='pagination' and @n='end']">-<xsl:apply-templates select="rs[@type='pagination' and @n='end']"/></xsl:if></a></xsl:when>
					<xsl:otherwise>[here]<xsl:apply-templates /></xsl:otherwise>
				</xsl:choose>
			</xsl:when>-->
			<!-- For page images -->
			<xsl:when test="/*//xref[@id='page-img-loc']"><a href="javascript:showPage('{./rs[@type='pagination'][1]/num[1]/text()}');" 
				title="View these pages"><xsl:apply-templates select="rs[@type='pagination'][1]"/><xsl:if 
				test="rs[@type='pagination' and @n='end']">-<xsl:apply-templates select="rs[@type='pagination' and @n='end']"/></xsl:if></a></xsl:when>
			<!-- when there is only vol beginning and the vol ending pagination (2 vols and 2 paginations) -->
			<xsl:when test="count(./rs[@type='vol'])=2 and count(./rs[@type='vol']/rs[@type='pagination'])=2">
				<xsl:for-each select="rs[@type='vol']">
					<xsl:variable name="volnum" select="format-number(number(@n),'###0')" />
					Volume <xsl:value-of select="$volnum"/>,
					<span class="vol hidden"><xsl:value-of select="$volnum"/></span><xsl:value-of select="rs[@type='pagination']/num[@type='page']"/>.<xsl:value-of select="rs[@type='pagination']/num[@type='line']"/>
					<xsl:if test="following-sibling::rs[@type='vol']"> - </xsl:if>
				</xsl:for-each>
			</xsl:when>
			<!-- if there are multiple volumes do a list -->
			<xsl:when test="count(./rs[@type='vol']) &gt; 1"><ul>
				<xsl:for-each select="rs[@type='vol']">
					<xsl:variable name="volnum" select="format-number(number(@n),'###0')"/>
					<li>Volume <xsl:value-of select="$volnum"/>, 
					<span class="start"><span class="vol hidden"><xsl:value-of select="$volnum"/></span><xsl:value-of select="rs[@type='pagination'][1]/num[@type='page']"/>.<xsl:value-of select="rs[@type='pagination'][1]/num[@type='line']"/></span><xsl:if test="rs[@type='pagination' and @n='end']">-<span class="end"><span class="vol hidden"><xsl:value-of select="$volnum"/></span><xsl:value-of select="rs[@type='pagination' and @n='end']/num[@type='page']"/>.<xsl:value-of select="rs[@type='pagination' and @n='end']/num[@type='line']"/></span></xsl:if></li>
				</xsl:for-each>
				</ul></xsl:when>
			<!-- when it's part of a concatenated master record, we'll want to flag it to be linked to view page, if exists -->
			<xsl:when test="ancestor::div[@n='tibbibls' and @type='container']"><rs><xsl:if 
				test="contains(/*//div[@type='master-edlist']//bibl[@n=$myedsig]/@rend,'pgimgs')"><xsl:attribute 
					name="class">masterpglinks <xsl:value-of select="$edid"/></xsl:attribute></xsl:if><xsl:apply-templates 
						select="rs[@type='pagination'][1]"/><xsl:if test="rs[@type='pagination' and @n='end']">-<xsl:apply-templates 
						select="rs[@type='pagination' and @n='end']"/></xsl:if></rs></xsl:when>
			<xsl:when test="./rs[@type='vol']"><xsl:apply-templates select="./rs[@type='vol']/rs[@type='pagination'][1]"/><xsl:if 
					test="./rs[@type='vol']/rs[@type='pagination' and @n='end']">-<xsl:apply-templates 
						select="./rs[@type='vol']/rs[@type='pagination' and @n='end']"/></xsl:if></xsl:when>
			<xsl:otherwise><xsl:apply-templates 
				select="rs[@type='pagination'][1]"/><xsl:if test="rs[@type='pagination' and @n='end']">-<xsl:apply-templates 
					select="rs[@type='pagination' and @n='end']"/></xsl:if></xsl:otherwise></xsl:choose></xsl:template>
	
	<xsl:template match="rs[@type='pagination']"><xsl:variable name="stpgvol"><xsl:value-of 
		select="preceding-sibling::rs/num[@type='vol']/text()"/></xsl:variable><xsl:variable name="otherEndVol"><xsl:choose>
			<xsl:when test="following-sibling::rs[@n='end']"><xsl:value-of 
				select="normalize-space(following-sibling::rs[@n='end']/num[@type='vol']/text())"/></xsl:when>
			<xsl:when test="preceding-sibling::rs[@n='start']"><xsl:value-of 
				select="normalize-space(preceding-sibling::rs[@n='start']/num[@type='vol']/text())"/></xsl:when>
		</xsl:choose></xsl:variable><xsl:variable name="classval"><xsl:choose><xsl:when test="not(@n) or @n=''">start</xsl:when><xsl:otherwise><xsl:value-of 
			select="@n"/></xsl:otherwise></xsl:choose></xsl:variable><xsl:if 
				test="num[@type='vol']/text() and not(number(num[@type='vol']/text())=number($stpgvol))">vol. <xsl:value-of 
					select="format-number(number(num[@type='vol']),'####')"/>, </xsl:if><xsl:if 
			test="num[@type='page']/text()"><span class="{$classval}"><xsl:if test="num[@type='vol']/text()"><span 
				class="vol hidden"><xsl:value-of select="num[@type='vol']/text()"/></span></xsl:if><xsl:value-of select="num[@type='page']"/><xsl:value-of 
				select="num[@type='side']"/>.<xsl:value-of select="num[@type='line']"/></span></xsl:if></xsl:template>
	
	<xsl:template match="p">
		<xsl:element name="p">
			<xsl:choose>
				<xsl:when test="@rend='byline'"><xsl:attribute name="class">cat-byline</xsl:attribute></xsl:when>
				<xsl:when test="@lang='eng'"><xsl:attribute name="class">eng</xsl:attribute></xsl:when>
				<xsl:when test="parent::discussion/@type='colophon'"><xsl:attribute name="class">colophon</xsl:attribute></xsl:when>
			</xsl:choose>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="q">
		<blockquote>
			<xsl:apply-templates />
		</blockquote>
	</xsl:template>
	
	<xsl:template match="title[parent::discussion and not(ancestor::tibbibl/@level='volume')]">
		<h3><xsl:apply-templates /></h3>
	</xsl:template>
	
	<xsl:template match="title[@lang='tib' and not(@rend='wyl')]">
		<span class="tib">
			<xsl:call-template name="tibbreak"><xsl:with-param name="txt"><xsl:call-template name="clearTibConvErrs"><xsl:with-param name="ttxt"><xsl:value-of select="text()[1]"/></xsl:with-param></xsl:call-template></xsl:with-param></xsl:call-template>
		</span>
		<xsl:if test="./comment()">
			<span class="sep"><xsl:text> </xsl:text></span><span class="wyl">
				<xsl:call-template name="diacritics"><xsl:with-param name="txt"><xsl:value-of select="./comment()"/></xsl:with-param></xsl:call-template>
			</span>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="title[@level='m' or @level='j' or @lang='san']">
		<xsl:element name="em">
			<xsl:choose>
				<xsl:when test="@lang='san' and @rend='eng'"><xsl:attribute name="class">san-title</xsl:attribute></xsl:when>
				<xsl:when test="@lang='san'"><xsl:attribute name="class">san</xsl:attribute></xsl:when>
			</xsl:choose>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="list">
		<xsl:choose>
			<xsl:when test="@rend">
				<xsl:element name="ol">
					<xsl:attribute name="type"><xsl:value-of select="@rend"/></xsl:attribute>
					<xsl:if test="@n"><xsl:attribute name="start"><xsl:value-of select="@n"/></xsl:attribute></xsl:if>
					<xsl:attribute name="class">catlist</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="ancestor::div/@type='cat-desc'">
				<ul class="bullet-blue">
					<xsl:apply-templates/>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<ul class="catlist">
					<xsl:apply-templates/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="item">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>
	
	<!-- any occurrences of a two or three letter initial should be surrounded by abbr type='resp'
		and the initials with a name should be added to the respdoc thl-resp-db.xml -->
	<xsl:template match="abbr[@type='resp']">
		<xsl:variable name="nm" select="normalize-space(translate(text(),'/',''))"/>
		<xsl:variable name="fullnm"><xsl:if test="string-length($nm) &lt; 5
			or (string-length($nm)=7 and substring($nm,1,3)='per')"><xsl:value-of select="normalize-space(document($respdoc)//item[./abbr/@id=$nm]/persName/text())"/></xsl:if></xsl:variable><xsl:choose>
			<xsl:when test="string-length(normalize-space($fullnm)) &gt; 0"><xsl:value-of select="$fullnm"/></xsl:when>
			<xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="label"><span class="label"><xsl:apply-templates /></span></xsl:template>
	
	<xsl:template match="xptr[@type='illustration']">
		<xsl:variable name="myParent_cat">../xml/<xsl:value-of select="/*//resources/xref[@n='parent-cat']"/></xsl:variable>
		<xsl:variable name="imgloc"><xsl:value-of select="document($myParent_cat)//resources/xref[@n='illustration-loc']/text()"/></xsl:variable>
		<xsl:variable name="url"><xsl:value-of select="concat($imgloc,translate(@n,'-','.'),'.',@targType)"/></xsl:variable>
		<xsl:variable name="myid"><xsl:value-of select="generate-id()"/></xsl:variable>
		<xsl:variable name="mylabel">Volume <xsl:value-of select="/*//tibid[@type='volume' and @system='number']/text()"/>, <xsl:value-of select="parent::*"/></xsl:variable>
		<a href="#" id="{$myid}" class="jqm-link" title="View Illustration Scan"><img src="/global/images/icon-image.gif" class="imgicon"/></a>
		<div class="jqmWindow" id="{$myid}-info">
			<div class="closebtn"><a href="#">Close</a></div>
			<div class="conx-content">
				<h3><xsl:value-of select="substring-before($mylabel,')')"/>): <span class="tib" style="font-weight: normal!important; font-size: 180%!important;"><xsl:value-of select="substring-after($mylabel,')')"/></span></h3>
				<p><img src="{$url}" title="{$mylabel}"/></p>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="xref">
		<xsl:choose>
			<xsl:when test="@type='mail' and contains(@rend,'safe')"><a href="javascript:linkTo_UnCryptMailto('{@n}','{rs[@type='subject']/text()}');"><xsl:apply-templates /></a></xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="lb"><br/></xsl:template>

	<xsl:template match="term[@lang='tib']"><xsl:choose>
		<xsl:when test="parent::gloss and @rend='wyl'"><span class="wyl emph"><xsl:value-of select="."/></span></xsl:when>
		<xsl:when test="parent::gloss"><span class="tib"><xsl:value-of select="."/></span></xsl:when>
		<xsl:when test="parent::title[@lang='eng']"><em><xsl:apply-templates /></em></xsl:when>
		<xsl:when test="@rend and not(@rend='uni' or @rend='unicode' or @rend='eng')"><span class="{@rend}"><xsl:apply-templates /></span></xsl:when>
	</xsl:choose></xsl:template>
	
	<xsl:template match="term[@lang='san']"><xsl:choose>
		<xsl:when test="parent::title[@lang='eng'] and not(contains(@rend,'parens'))"><em><xsl:apply-templates /></em></xsl:when>
		<xsl:when test="contains(@rend,'parens')"><span class="sansep"><xsl:text> (</xsl:text></span><span class="san"><xsl:apply-templates/><xsl:if 
			test="contains(@rend,'plural')"><xsl:value-of select="substring-after(@rend,'plural:')"/></xsl:if></span><span class="sansep"><xsl:text>)</xsl:text></span></xsl:when>
		<xsl:otherwise><span class="san"><xsl:apply-templates /></span></xsl:otherwise>
	</xsl:choose></xsl:template>

	<xsl:template match="gloss[@rend='parens']"><span class="tibparens">(</span><xsl:for-each 
		select="term"><xsl:apply-templates select="."/><xsl:if test="following-sibling::term"><span class="sep">, 
		</span></xsl:if></xsl:for-each><span class="tibparens">)</span></xsl:template>

	<xsl:template match="sic"><xsl:variable name="meid" select="generate-id(.)"/><xsl:apply-templates 
	/> [<em>sic</em>]<xsl:if test="@corr and not(@corr='')"><a class="jqm-link noteref" id="{$meid}" href="#">†</a>
		<div id="{$meid}-info" class="jqmWindow" style="height:200px !important; width: 450px !important;">
		<div class="closebtn"><a href="#">Close</a></div>
			<div class="conx-content" style="height:180px !important; width: 430px !important; overflow: auto;">
				<h4>“<xsl:apply-templates />” [<em>sic</em>]</h4>
				<p>The corrected reading would be: “<xsl:value-of select="@corr"/>”</p>
			</div>
		</div></xsl:if>
	</xsl:template>
		
	<xsl:template match="hi">
		<xsl:choose>
			<!-- Rend Bold or Strong -->
			<xsl:when test="@rend='bold' or @rend='strong'"><b><xsl:apply-templates/></b></xsl:when>
			<!-- Rend No Bold -->
			<xsl:when test="@rend='nobold'"><span style="font-weight: normal;"><xsl:apply-templates/></span></xsl:when>
			<!-- Rend Italic or Weak -->
			<xsl:when test="@rend='italic' or @rend='italics' or @rend='weak' or (not(@rend) and not(@lang='tib'))"><i><xsl:apply-templates/></i></xsl:when>
			<!-- Rend No Italics -->
			<xsl:when test="@rend='noital'"><span style="font-style: normal;"><xsl:apply-templates/></span></xsl:when>
			<!-- Rend Underline -->
			<xsl:when test="@rend='underline'"><u><xsl:apply-templates/></u></xsl:when>
			<!-- Rend Normal -->
			<xsl:when test="@rend='normal'"><span style="font-weight: normal; font-style: normal; text-decoration: none;"><xsl:apply-templates/></span></xsl:when>
			<!-- Rend Strike Through -->
			<xsl:when test="@rend='strikethru'"><xsl:element name="span"><xsl:attribute name="style">text-decoration: line-through;</xsl:attribute><xsl:apply-templates/></xsl:element></xsl:when>
			<!-- Rend Superscript -->
			<xsl:when test="@rend='super'"><xsl:element name="span"><xsl:attribute name="style">vertical-align: super;</xsl:attribute><xsl:apply-templates/></xsl:element></xsl:when>
			<!-- Rend Subscript -->
			<xsl:when test="@rend='sub'"><xsl:element name="span"><xsl:attribute name="style">vertical-align: sub;</xsl:attribute><xsl:apply-templates/></xsl:element></xsl:when>
			<!-- Rend Capitalize -->
			<xsl:when test="@rend='caps'"><xsl:element name="span"><xsl:attribute name="style">text-transform: capitalize;</xsl:attribute><xsl:apply-templates/></xsl:element></xsl:when>
			<!-- Rend Small Caps -->
			<xsl:when test="@rend='smcaps'"><xsl:element name="span"><xsl:attribute name="style">font-variant: small-caps;</xsl:attribute><xsl:apply-templates/></xsl:element></xsl:when>
			<!-- Rend All Caps -->
			<xsl:when test="@rend='allcaps'"><xsl:element name="span"><xsl:attribute name="style">text-transform: capitalize;</xsl:attribute><xsl:apply-templates/></xsl:element></xsl:when>
			<!-- Other Rend means rend attribute contains a style instruction apply it here -->
			<xsl:when test="@rend and not(@rend='') and not(@rend='wyl')"><xsl:element name="span"><xsl:attribute name="style"><xsl:value-of select="@rend"/></xsl:attribute><xsl:apply-templates/></xsl:element></xsl:when>
			<!-- Tibetan hi elements -->
			<xsl:when test="@lang='tib' and @rend='wyl'"><i><xsl:apply-templates /></i></xsl:when>
			<xsl:when test="@lang='tib' or @rend='tib'"><xsl:apply-templates /></xsl:when>
			<!-- Other rend attributes just become classes -->
			<xsl:when test="@rend"><span class="{@rend}"><xsl:apply-templates/></span></xsl:when>
			<!-- Otherwise falls through the cracks do nothing-->
			<xsl:otherwise><xsl:apply-templates/><xsl:comment>Unknown rend attribute value: <xsl:value-of select="@rend"/>!</xsl:comment></xsl:otherwise>
		</xsl:choose>
	</xsl:template> 
	<!-- End of HI template -->
	
	<xsl:template match="add"><span class="add"><xsl:apply-templates /></span></xsl:template>
	
	<xsl:template match="*[@rend='none']"/>
	
	<!--Tibetan text template -->
	<xsl:template match="text()[ancestor::*[@lang='tib' and not(@rend='wyl' or @rend='phon')] and not(parent::*/@lang='eng' or parent::*/@rend='wyl' or parent::*/@rend='eng')]"><span class="tib"><xsl:choose>
		<xsl:when test="string-length(.) &gt; 1500"><xsl:value-of select="."/></xsl:when>
		<xsl:otherwise><xsl:call-template name="tibbreak">
		<xsl:with-param name="txt"><xsl:call-template name="clearTibConvErrs"><xsl:with-param name="ttxt" select="."/></xsl:call-template></xsl:with-param>
	</xsl:call-template></xsl:otherwise>
	</xsl:choose></span></xsl:template>
	
	<!-- Note Templates -->
	<xsl:template match="note">
		<!-- In order to not place the content <div> within an inline element, the content divs (which are hidden)
			need to be placed at the end of the output HTML. and so another call for-each note needs to be done at the 
			end of the output.-->
		<xsl:variable name="nid"><xsl:choose>
			<xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
		</xsl:choose></xsl:variable>
		<xsl:variable name="notenum" select="count(preceding::note) + 1"/>
		<a class="jqm-link noteref" id="{$nid}" href="#"><xsl:value-of select="$notenum"/></a>
	</xsl:template>
	
	<xsl:template name="doNoteContent">
		<xsl:variable name="nid"><xsl:choose>
			<xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
		</xsl:choose></xsl:variable>
		<xsl:variable name="notenum" select="count(preceding::note) + 1"/>
		<xsl:variable name="resp"><xsl:value-of select="@resp"/></xsl:variable>
		<xsl:variable name="respFull"><xsl:value-of select="normalize-space(document($respdoc)//item[./abbr/@id=$resp]/persName/text())"/></xsl:variable>
		<div id="{$nid}-info" class="jqmWindow" style="height:250px !important; width: 520px !important;">
			<div class="closebtn"><a href="#">Close</a></div>
			<div class="conx-content" style="height:230px !important; width: 500px !important; overflow: auto;">
				<h4>Note <xsl:value-of select="$notenum"/> for 
					<xsl:choose>
						<xsl:when test="ancestor::div/@type='cat-desc'">
							Description of <xsl:value-of select="ancestor::div[@type='cat-desc']/@n"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/*//tibid[@type='edition' and @system='letter']/text()[1]"/>
							<xsl:text> </xsl:text>
							<xsl:choose>
								<xsl:when test="ancestor::tibbibl/@level='volume'">
									Volume <xsl:value-of select="format-number(/*//tibid[@type='volume' and @system='number'][1]/text()[1],'##0')"/>
								</xsl:when>
								<xsl:when test="ancestor::tibbibl/@level='text'">
									Text <xsl:value-of select="format-number(/*//tibid[@type='text' and @system='number'][1]/text()[1],'###0')"/>
								</xsl:when>
								<xsl:otherwise>
									Record
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose></h4>
				<p class="{@lang}"><xsl:apply-templates /> <xsl:if test="@resp"><span class="eng"><xsl:text> (</xsl:text><xsl:choose><xsl:when test="not($respFull='')"><xsl:value-of select="$respFull"/></xsl:when><xsl:otherwise><xsl:value-of select="$resp"/></xsl:otherwise></xsl:choose><xsl:text>)</xsl:text></span></xsl:if></p>
			</div>
		</div>
	</xsl:template>
	
	<!-- General Named Templates -->
	<!-- Was doControls -->
	<xsl:template name="doResources">
		<xsl:variable name="rscNum"><xsl:value-of select="count(document($parent_cat)//resources/xref[not(@type='master-cat')]) + count(/*//resources/xref[not(@type='parent-cat')])"/></xsl:variable>
		<div id="resources">
			<h3>Associated Resources</h3>
			<ul class="bibldesc">
			<xsl:choose>
				<xsl:when test="number($rscNum) = 0">
					<li style="margin-bottom: 8px;">
						No associated resources for this are currently available, but we welcome contributions of scans, 
						input text editions, volume or chapter summaries, 
						scholarly essays, or any other type of contribution - 
						please contact us at 
						<a class="safe-contact" href="javascript:linkTo_UnCryptMailto('nbjmup;uimAdpmmbc/jud/wjshjojb/fev');">
							<img src="/global/images/contact/contact-thl.gif" style="display: inline!important;"/>
						</a>
					</li>
				</xsl:when>
				<xsl:when test="$txtid=''">
					<xsl:for-each select="/*//resources/xref[not(@type='parent-cat')]">
						<xsl:call-template name="doResource"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="textstatus"><xsl:if test="/*//resources/xref[@type='text' and @n='missing']">missing</xsl:if></xsl:variable>
					<xsl:for-each select="/*//resources/xref[not(@type='parent-cat')] | 
						document($parent_cat)//resources/xref[not(@type='master-cat')]">
						<xsl:if test="not($textstatus='missing' and not(@type='text' and @n='missing'))"><xsl:call-template name="doResource"/></xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
			<li><a id="metalink" class="icon-info" href="javascript:simpleToggle('#metadata'); toggleLink('#metalink');">Cataloging Metadata</a></li>
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template name="doResource">
		<li>
			<xsl:choose>
				<xsl:when test="@type='page-img-loc' and @rend='text'">
					<xsl:element name="a">
						<xsl:attribute name="class">nolink icon-page-stack</xsl:attribute>
						<xsl:apply-templates select="text() | *[not(self::ptr)]"/>
					</xsl:element>
					<xsl:apply-templates select="ptr"/>
				</xsl:when>
				<xsl:when test="@type='page-img-loc'">
					<xsl:variable name="options"><xsl:value-of select="@rend"/></xsl:variable>
					<span class="hasPages hasPageImgs {$options}"/>
					<xsl:element name="a">
						<xsl:attribute name="class">icon-page-stack</xsl:attribute>
						<xsl:attribute name="href">javascript: THLcat.showTextsPages('scan');</xsl:attribute> Scanned Pages </xsl:element>				</xsl:when>
				<xsl:when test="@type='outline'">
					<xsl:element name="a">
						<xsl:attribute name="class">icon-outline reswin</xsl:attribute>
						<xsl:attribute name="href"><xsl:value-of select="$edid"/>/<xsl:value-of select="$txtid"/>/outline</xsl:attribute>Text Outline Only </xsl:element></xsl:when>
				<xsl:when test="@type='text' and not(normalize-space($txtid)='') and not(@n='missing')">
					<xsl:variable name="n" select="@n"/>
					<xsl:variable name="firstTxt"><xsl:if test="contains($n,'-')"><xsl:value-of 
						select="number(substring-before($n,'-')) - 1"/></xsl:if></xsl:variable>
					<xsl:variable name="lastTxt"><xsl:if test="contains($n,'-')"><xsl:value-of 
						select="number(substring-after($n,'-')) + 1"/></xsl:if></xsl:variable>
					<xsl:variable name="tnum" select="number($txtid)"/>
					<xsl:variable name="isDig"><xsl:if test="@rend='digital'"><xsl:text> </xsl:text>digital</xsl:if></xsl:variable>
					<xsl:if test="$tnum &gt; $firstTxt and $tnum &lt; $lastTxt">
						<span class="hasPages hasDigitalTexts"/>
					<xsl:element name="a">
						<xsl:attribute name="class">icon-text<xsl:value-of select="$isDig"/></xsl:attribute>
						<xsl:attribute name="href">javascript: THLcat.showTextsPages('unicode');</xsl:attribute> 
						Text  Edition </xsl:element></xsl:if></xsl:when>
				<xsl:when test="/*//resources/xref[@type='text' and @n='missing']">
					<xsl:element name="a">
						<xsl:attribute name="class">icon-text missing</xsl:attribute>
						Text Not Avaliable
					</xsl:element>
				</xsl:when>
				<xsl:when test="@type='link'">
					<xsl:element name="a">
						<xsl:attribute name="class">icon-info</xsl:attribute>
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="./xptr/@type='wiki'">javascript:wikiLinkLoad('<xsl:value-of select="./xptr/@n" disable-output-escaping="yes"/>');</xsl:when>
								<xsl:when test="./xptr/@type='essay'">#essay=<xsl:value-of select="./xptr/@n" disable-output-escaping="yes"/></xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<xsl:value-of select="text()"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</li>
	</xsl:template>
	
	<xsl:template match="ptr[@n='resource']">
		<xsl:variable name="tgt"><xsl:value-of select="@target"/></xsl:variable>
		<xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
		<xsl:for-each select="/*//*[@id=$tgt]/bibl[@rend=$type]">
			<div class="mpl-parent" style="display: inline !important;"><a class="masterPgLink" href="#{@n}"><xsl:value-of select="text()"/></a><xsl:if test="following-sibling::bibl"><xsl:text>, </xsl:text></xsl:if></div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="doMetaLink">
		<span id="metalink">
			<a class="icon-info" href="javascript: simpleToggle('#metadata',true);" onclick="javascript: toggleLink(this);">Cataloging Metadata</a>
		</span>
	</xsl:template>
	
	<xsl:template name="doSource">
		<xsl:if test="not(normalize-space(.)='')">
			<xsl:variable name="src"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
			<!--	Check to see if it's in THL Responsibility DB and use name from there -->
			<xsl:choose>
				<!-- if it's got initials from thl-resp-db or has a comma and date, look up name in db -->
				<xsl:when test="string-length($src) &lt; 4 or contains($src,'per') or (contains($src,',') and contains($src,'-'))">
					<xsl:variable name="who"><xsl:choose>
						<xsl:when test="contains($src,',')"><xsl:value-of select="normalize-space(substring-before($src,','))"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="normalize-space($src)"/></xsl:otherwise>
					</xsl:choose></xsl:variable>
					<xsl:variable name="date"><xsl:if test="contains($src,',') and contains($src,'-')"><xsl:value-of select="normalize-space(substring-after($src,','))"/></xsl:if></xsl:variable>
					(<xsl:value-of select="normalize-space(document($respdoc)//item[./abbr/@id=$who]/persName/text())"/><xsl:if test="not(normalize-space($date)='')"> –
						<xsl:call-template name="formatDate"><xsl:with-param name="date" select="$date"/></xsl:call-template></xsl:if>)
				</xsl:when>
				<!-- Otherwise, call template for source element -->
				<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<!-- Page Viewer Templates -->
	<xsl:template name="makePageViewer">
		<xsl:param name="parent_doc"/>
		<xsl:param name="master_doc"/>
		<xsl:param name="collid"/>
		<xsl:param name="siglaid"/>
		<xsl:param name="edid"/>
		<xsl:param name="volid"/>
		<xsl:param name="txtnum"/>
		<xsl:param name="gentibtitle"/>
		<xsl:param name="firstPg"/>
		<xsl:param name="firstPgImg"/>
		<xsl:param name="sidesAdj"/>
		<xsl:variable name="volidnum"><xsl:choose>
			<xsl:when test="string(number($volid))='NaN'"><xsl:value-of select="$volid"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="number($volid)"/></xsl:otherwise>
		</xsl:choose></xsl:variable>
		<div id="pvcontents">
			<div id="pvtop">
				<div id="pvcontrols">
					<form name="pvform" id="pvform" action="#" method="post">
						<table cellpadding="2">
							<tr>
								<td>
									<span class="pvlabel">Edition</span>
								</td>
								<td align="left">
									<span class="pvlabel">Text</span>
								</td>
								<td align="left">
									<span class="pvlabel">Section</span>
								</td>
								<td>
									<!-- cell over prev button -->
								</td>
								<td>
									<span class="pvlabel">Volume</span>
								</td>
								<td>
									<span class="pvlabel">Page</span>
								</td>
								<td>
									<!-- cell over next button -->
								</td>
								<td>
									<span class="pvlabel">View</span>
								</td>
								<td>
									<!-- cell over page type -->
								</td>
								<td> 
									<!-- cell over back link -->
								</td>
							</tr>
							<tr>
								<td>
									<input type="text" name="edname" id="edname" size="15"/>
								</td>
								<td>
									<input value=" n/a" name="txtnum" size="3"/>
								</td>
								<td>
									<div id="chapSelectPlace">
										<select name="sections"><option value="0"> n/a <xsl:value-of select="$space" disable-output-escaping="yes"/></option></select>
									</div>
								</td>
								<td>
									<input name="prevbutton" value="Previous" type="button" class="button"/>
								</td>
								<td>
									<input value="1" name="vnum" size="5"/>
									<input value="no" id="vchg" type="hidden"/>
								</td>
								<td>
									<input value="1b" name="pnum" size="5"/>
								</td>
								<td>
									<input name="nextbutton" value=" Next " type="button" class="button"/>
								</td>
								<td>
									<select name="pagetype">
										<option value="unicode" selected="selected">Digital Text</option>
										<option value="scan">Scanned Pages</option>
									</select>
								</td>
								<td>
									<a href="#" id="bibllnk">Back to Catalog Record</a>
								</td>
							</tr>
							<!--<tr id="TextHitNavRow" style="display: none;">
								<td colspan="2" align="center" valign="bottom" style="padding-top: 16px ;"><a class="prev"><img src="/global/images/icon-previous.png" title="Go to Previous Page with Hits"/> </a></td>
								<td colspan="6" align="center" valign="bottom">
								<span class="numOfPgs"></span> Pages with Hits in This Text
								</td>
								<td colspan="2" align="center" valign="bottom"><a class="next"><img src="/global/images/icon-next.png" title="Go to Next Page with Hits"/></a></td>
								</tr>-->
						</table>
					</form>
					<div id="txtHitDiv" style="display: none;">
					</div>
				</div>
				<div id="pvinfopane">
					<h3><xsl:value-of select="document($parent_doc)//teiHeader/fileDesc/titleStmt/title[@lang='eng']"/>
						— Volume<xsl:if test="contains($volid,'-')">s</xsl:if><xsl:text> </xsl:text><xsl:choose>
							<xsl:when test="string(number($volid))='NaN'"><xsl:value-of select="$volid"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="number($volid)"/></xsl:otherwise>
						</xsl:choose></h3>
					<h2>
						<span class="capitalize"><xsl:value-of select="$siglaid"/></span>: 
						<span class="tib"><xsl:call-template name="tibbreak">
							<xsl:with-param name="txt"><xsl:call-template name="clearTibConvErrs"><xsl:with-param name="ttxt"><xsl:value-of select="$gentibtitle"/></xsl:with-param></xsl:call-template></xsl:with-param>
						</xsl:call-template></span>
						<xsl:text> </xsl:text>
						<span class="volspan">(<xsl:for-each 
							select="tibbibl[@level='text']/physdecl/pagination/rs[@type='vol']">Vol. <xsl:value-of select="format-number(number(@n),'###')"/>, 
							<xsl:apply-templates select="." mode="pagerange"/><xsl:if test="not(position()=last())">; </xsl:if>
						</xsl:for-each>)</span>
					</h2>
					<div class="chapinfo"></div>
					<ul id="chapstats" class="hidden">
						<xsl:for-each select="/*//sections/tibanal/tibbibl">
							<xsl:call-template name="summarizeTibbibl"/>
						</xsl:for-each>
						<xsl:if test="not($collid='ngb')">
						<li id="chapSelect">
							<span class="hidden" id="ismultivol"><xsl:if test="count(/tibbibl[@level='text']/physdecl/pagination/rs[@type='vol']) &gt; 1">yes</xsl:if></span>
							<xsl:choose>
								<xsl:when test="/*/sections">
									<span class="pvlabel">Section</span>
									<select name="chpnum" id="chpnum"
										onchange="JavaScript:pvChange('section')">
										<xsl:choose>
											<xsl:when test="/*/sections//tibbibl[@level='chapgroup']">
												<xsl:for-each select="/*/sections//tibbibl[@level='chapgroup']">
													<xsl:choose>
														<xsl:when test="tibanal/tibbibl[@level='chapter']">
															<xsl:variable name="cgid"><xsl:choose>
																<xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
																<xsl:when test="@n"><xsl:value-of select="@n"/></xsl:when>
																<xsl:otherwise>s<xsl:value-of select="normalize-space(substring-after(head[1]/text()[1],'ection '))"/></xsl:otherwise>
															</xsl:choose></xsl:variable>
															<optgroup label="{head/text()}" id="optgrp-{$cgid}">
																<xsl:for-each select="tibanal/tibbibl[@level='chapter']"><xsl:call-template name="doOption"/></xsl:for-each>
															</optgroup>
														</xsl:when>
														<xsl:otherwise>
															<xsl:call-template name="doOption"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>
												<xsl:for-each select="/*/sections//tibbibl[@level='chapter']">
													<xsl:call-template name="doOption"/>
												</xsl:for-each>
											</xsl:otherwise>
										</xsl:choose>
									</select>
								</xsl:when>
								<xsl:otherwise>
									<span class="pvlabel">
										Chapters Not Available.
									</span>
								</xsl:otherwise>
							</xsl:choose>
						</li>
						</xsl:if>
					</ul>
					<ul id="volstats" class="hidden">
						<li><span id="pgadj"><xsl:value-of select="$sidesAdj"/></span></li>
						<xsl:if test="count(/*/physdecl/pagination/rs[@type='vol']) &gt; 1">
							<xsl:for-each select="/*/physdecl/pagination/rs[@type='vol']">
								<xsl:variable name="vnum"><xsl:value-of select="format-number(number(@n),'000')"/></xsl:variable>
								<xsl:variable name="vol_doc"><xsl:value-of
										select="concat('../xml/',$collid,'/',$edid,'/volumes/',
										$collid,'-',$edid,'-v',
										format-number($vnum,'000'),'-bib.xml')"/></xsl:variable>
								<xsl:variable name="vpadj"><xsl:value-of select="document($vol_doc)//extent[@class='sides-before-1a']/text()"/></xsl:variable>
								<li><span id="pgadj-{$vnum}"><xsl:choose>
									<xsl:when test="normalize-space($vpadj)=''">0</xsl:when>
									<xsl:otherwise><xsl:value-of select="$vpadj"/></xsl:otherwise>
								</xsl:choose></span></li>
							</xsl:for-each>
						</xsl:if>
					</ul>
				</div>
			</div>
			<div id="pvbottom">
				<div id="pvimg"> 
					<p style="margin: 0em">
						<img name="pgImage" border="1" src="{$firstPgImg}" alt="{$firstPgImg}" 
							style="margin: 0em"/>
						<xsl:comment>First page image is: <xsl:value-of select="$firstPgImg"/></xsl:comment>
					</p>
				</div>
				<div id="pvcopyright">
					<!--<xsl:if test="$collid='ngb'"> All folio scans courtesy of the <a
							href="http://www.tbrc.org">Tibetan Buddhist Resource Center</a>
							</xsl:if>-->
				</div>
			</div>
			<div id="pvtextbottom">
				<div id="txtload"> <div class="container"> <p>Please wait while the text loads...</p> </div> </div>
			</div>
			<xsl:text disable-output-escaping="yes"><![CDATA[
				<script type="text/javascript">
					try {
						PageViewer.init(THLcat);
					} catch(e) {
						if(typeof(console) == "object") { 
							try {
								//console.trace();
								//console.info("");
								//console.info(e.toString());
							} catch(e) {}
						}
					}
				</script>
			]]></xsl:text>
		</div>
	</xsl:template>
	
	<xsl:template name="doOption">
		<xsl:if test="not(@n='a0') and not(@n='c0')">
			<option value="{normalize-space(tibiddecl/tibid/text())}">
				<xsl:choose>
					<xsl:when test="contains(comment()[1],'Chapter')">
						<xsl:value-of select="comment()[1]"/>
					</xsl:when>
					<xsl:when test="head/text()">
						<xsl:value-of select="head"/>
					</xsl:when>
					<xsl:when test="titledecl/title[@lang='eng']/text()">
						<xsl:value-of select="titledecl/title[@lang='eng']/text()"/>
					</xsl:when>
					<xsl:otherwise>
						<span class="tib"><xsl:value-of select="titledecl/title[@lang='tib']/text()"/></span>
					</xsl:otherwise>
				</xsl:choose>
			</option>
		</xsl:if>
	</xsl:template>
	
	<!-- Text info for page viewer. Iterates through section tibbibls -->
	<xsl:template name="summarizeTibbibl">
		<xsl:if test="not(@n='a0') and not(@n='c0')">
			<xsl:variable name="mytype"><xsl:value-of select="@level"/></xsl:variable>
			<xsl:variable name="myid"><xsl:choose>
				<xsl:when test="@n"><xsl:value-of select="@n"/></xsl:when>
				<xsl:when test="tibiddecl[1]/tibid[@type=$mytype
					and @system='number']/text()"><xsl:value-of 
						select="normalize-space(./tibiddecl[1]/tibid[@type=$mytype
						and @system='number']/text())"/></xsl:when>
			</xsl:choose></xsl:variable>
			<li id="{$myid}" class="tiblinfo">
				<span class="id"><xsl:value-of select="$myid"/></span>
				<span class="type"><xsl:value-of select="@level"/></span>
				<span class="head"><xsl:choose>
					<xsl:when test="head/text()">
						<xsl:value-of select="head"/>
					</xsl:when>
					<xsl:when test="titledecl/title[@lang='eng']/text()">
						<xsl:value-of select="titledecl/title[@lang='eng']/text()"/>
					</xsl:when>
					<xsl:when test="contains(comment()[1],'Chapter')">
						<xsl:value-of select="comment()[1]"/>
					</xsl:when>
					<xsl:otherwise>
						<span class="tib"><xsl:value-of select="titledecl/title[@lang='tib']/text()"/></span>
					</xsl:otherwise>
				</xsl:choose></span>
				<span class="title-tib"><xsl:call-template name="tibbreak"><xsl:with-param name="txt"><xsl:call-template name="clearTibConvErrs"><xsl:with-param name="ttxt"><xsl:value-of select="titledecl/title[@lang='tib']"/></xsl:with-param></xsl:call-template></xsl:with-param></xsl:call-template></span>
				<span class="title-wyl"><xsl:value-of select="titledecl/title[@lang='tib']/comment()"/></span>
				<span class="title-eng"><xsl:value-of select="titledecl/title[@lang='eng']"/></span>
				<span class="stpg"><xsl:if test="physdecl/pagination/rs[1]/num[@type='vol']"><xsl:value-of select="number(physdecl/pagination/rs[1]/num[@type='vol']/text())"/>.</xsl:if><xsl:value-of select="physdecl/pagination/rs[1]/num[@type='page']"/>.<xsl:value-of select="physdecl/pagination/rs[1]/num[@type='line']"/></span>
				<span class="endpg"><xsl:choose>
					<xsl:when test="physdecl/pagination/rs[@n='end']"><xsl:if test="physdecl/pagination/rs[@n='end']/num[@type='vol']"><xsl:value-of select="number(physdecl/pagination/rs[@n='end']/num[@type='vol']/text())"/>.</xsl:if><xsl:value-of select="physdecl/pagination/rs[@n='end']/num[@type='page']"/>.<xsl:value-of select="physdecl/pagination/rs[@n='end']/num[@type='line']"/></xsl:when>
					<xsl:otherwise><xsl:if test="physdecl/pagination/rs[1]/num[@type='vol']"><xsl:value-of select="number(physdecl/pagination/rs[1]/num[@type='vol']/text())"/>.</xsl:if><xsl:value-of select="physdecl/pagination/rs[1]/num[@type='page']"/>.<xsl:value-of select="physdecl/pagination/rs[1]/num[@type='line']"/></xsl:otherwise>
				</xsl:choose></span>
				<xsl:if test="not(tibanal/tibbibl)"><span class="haschaps">false</span></xsl:if>
				<xsl:if test="tibanal/tibbibl">
					<span class="haschaps">true</span>
					<ul>
						<xsl:for-each select="tibanal/tibbibl">
							<xsl:call-template name="summarizeTibbibl"/>
						</xsl:for-each>
					</ul>
				</xsl:if>
			</li>
		</xsl:if>
	</xsl:template>
	
	<!-- Format Date template -->
	<!-- template for formatting dates //-->
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<xsl:variable name="year" select="substring-before($date,'-')"/>
		<xsl:variable name="month"><xsl:choose>
                        <xsl:when test="substring-before(substring-after($date,'-'),'-')=''"><xsl:value-of select="substring-after($date,'-')"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="substring-before(substring-after($date,'-'),'-')"/></xsl:otherwise>
                 </xsl:choose>
                </xsl:variable>
		<xsl:variable name="day" select="normalize-space(substring-after(substring-after($date,'-'),'-'))"/>
		<xsl:variable name="dayout"><xsl:choose><xsl:when test="string-length($day)=2 and substring($day,1,1)='0'"><xsl:value-of select="substring($day,2,1)"/></xsl:when><xsl:otherwise><xsl:value-of select="$day"/></xsl:otherwise></xsl:choose></xsl:variable>
		
		<xsl:choose>
			<xsl:when test="not(contains($date,'-'))">
				<xsl:value-of select="$date"/>
			</xsl:when>

  	<!-- if the date is in MM-DD-YYYY format //-->
			<xsl:when test="string-length($year) = 3 and string-length($day)=4">
				<xsl:choose>
					<xsl:when test="$year='1' or $year='01'">January</xsl:when>
					<xsl:when test="$year='2' or $year='02'">February</xsl:when>
					<xsl:when test="$year='3' or $year='03'">March</xsl:when>
					<xsl:when test="$year='4' or $year='04'">April</xsl:when>
					<xsl:when test="$year='5' or $year='05'">May</xsl:when>
					<xsl:when test="$year='6' or $year='06'">June</xsl:when>
					<xsl:when test="$year='7' or $year='07'">July</xsl:when>
					<xsl:when test="$year='8' or $year='08'">August</xsl:when>
					<xsl:when test="$year='9' or $year='09'">September</xsl:when>
					<xsl:when test="$year='10'">October</xsl:when>
					<xsl:when test="$year='11'">November</xsl:when>
					<xsl:when test="$year='12'">December</xsl:when>
				</xsl:choose>
				<xsl:value-of select="concat(' ',normalize-space($year),', ',normalize-space($day))"/>
			</xsl:when>
	
	<!-- If the date is in THDL standard YYYY-MM-DD format -->
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$month='1' or $month='01'">January</xsl:when>
					<xsl:when test="$month='2' or $month='02'">February</xsl:when>
					<xsl:when test="$month='3' or $month='03'">March</xsl:when>
					<xsl:when test="$month='4' or $month='04'">April</xsl:when>
					<xsl:when test="$month='5' or $month='05'">May</xsl:when>
					<xsl:when test="$month='6' or $month='06'">June</xsl:when>
					<xsl:when test="$month='7' or $month='07'">July</xsl:when>
					<xsl:when test="$month='8' or $month='08'">August</xsl:when>
					<xsl:when test="$month='9' or $month='09'">September</xsl:when>
					<xsl:when test="$month='10'">October</xsl:when>
					<xsl:when test="$month='11'">November</xsl:when>
					<xsl:when test="$month='12'">December</xsl:when>
				</xsl:choose>
                                <xsl:choose>
                                        <xsl:when test="$dayout=''"><xsl:value-of select="concat(' ',normalize-space($year))"/></xsl:when>
                                        <xsl:otherwise><xsl:value-of select="concat(' ',normalize-space($dayout),', ',normalize-space($year))"/></xsl:otherwise>
                                </xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Replace Tibe Conversion error messages -->
	<xsl:template name="clearTibConvErrs">
		<xsl:param name="ttxt"/><xsl:choose>
			<xsl:when test="contains($ttxt,'[#ERROR')"><xsl:value-of select="substring-before($ttxt,'[#ERROR')"/><span class="eng">[<xsl:value-of 
				select="substring-before(substring-after(substring-after($ttxt,'[#ERROR'),'{'),'}')"/>]</span><xsl:value-of 
					select="substring-after($ttxt,'parses.]')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$ttxt"/></xsl:otherwise>
		</xsl:choose></xsl:template>
	
	<!-- Tibbreak: Named template to insert a zero-width space after every tsek in Unicode Tibetan script -->
	<xsl:template name="tibbreak">
		<xsl:param name="txt"/>
		<xsl:variable name="bef">
			<xsl:value-of select="substring-before($txt,'་')"/>
		</xsl:variable>
		<xsl:variable name="aft">
			<xsl:value-of select="substring-after($txt,'་')"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($aft) &gt; 1">
				<xsl:value-of select="concat($bef,'་','&#x200b;')"/>
				<xsl:call-template name="tibbreak">
					<xsl:with-param name="txt" select="$aft"></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$txt"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="diacritics"><xsl:param name="txt"/><xsl:choose><xsl:when test="contains($txt,'R+Y')"><xsl:call-template name="diacritics"><xsl:with-param name="txt" select="concat(substring-before($txt,'R+Y'),'ry',substring-after($txt,'R+Y'))"/></xsl:call-template></xsl:when><xsl:otherwise><xsl:value-of select="translate(translate($txt,concat($extWyl,'_'),concat($diaWyl,' ')),'+','')"/></xsl:otherwise></xsl:choose></xsl:template>
	
</xsl:stylesheet>
