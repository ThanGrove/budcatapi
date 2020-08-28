<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" version="2.0">
	
	<xsl:output method="text" 
			encoding="UTF-8" 
			indent="no"/>
	
	<xsl:param name="collid"/>
	<xsl:param name="edid"/>
	<xsl:param name="txtid"/>
	 
	<xsl:template match="/">
		<xsl:call-template name="tibbiblJSON"/>
	</xsl:template>
	
	<xsl:include href="cat-gentemps.xsl"/>
	<xsl:include href="biblSummary-inc.xsl"/>
	
</xsl:stylesheet>
