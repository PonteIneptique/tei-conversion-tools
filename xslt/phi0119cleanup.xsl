<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output indent="yes"></xsl:output>
    <xsl:template match="node()|@*|comment()">
        <!-- Copy the current node -->
        <xsl:copy>
            <!-- Including any child nodes it has and any attributes -->
            <xsl:apply-templates select="node()|@*|comment()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*:lemma[@targOrder]">
        <xsl:element name="q"><xsl:apply-templates/></xsl:element>
    </xsl:template>
    <xsl:template match="*:milestone/@unit">
        <xsl:attribute name="type" select="." />
    </xsl:template>
    
    
</xsl:stylesheet>
