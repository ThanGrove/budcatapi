<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- General Variables used in styles --> 
    <xsl:variable name="lc">abcdefghijklmnopqrstuvwxyzāáàäēéèëiíìïōóòöūúùüḍḥḷḹṃṁṇṅñṛṝśṣṭ</xsl:variable>
    <xsl:variable name="uc">ABCDEFGHIJKLMNOPQRSTUVWXYZĀÁÀÄĒÉÈËĪÍÌÏŌÓÒÖŪÚÙÜḌḤḶḸṂṀṆṄÑṚṜŚṢṬ</xsl:variable>
    <xsl:variable name="space"><xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;]]></xsl:text></xsl:variable>
    <xsl:variable name="extWyl">ADHILMNRSTU_+</xsl:variable>
    <xsl:variable name="diaWyl">āḍḥīḷṃṇṛṣṭū &#x200B;</xsl:variable><!-- replacing "+" with zero-width space to prevent it from being replaced by a space -->
    <xsl:variable name="apos">'</xsl:variable>
</xsl:stylesheet>