<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:param name="container_type" select="'poem'" />
    <xsl:param name="renumber_div" select="false()" />
    
    <xsl:template match="*:l">
        <xsl:variable name="container" select="ancestor::*:div[@subtype=$container_type]" />
        <xsl:variable name="seq" select="$container//*:l" />
        <xsl:copy>
            <xsl:attribute name="n" select="index-of($seq, current())"/>
            <xsl:apply-templates  select="node()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*:div">
        <xsl:variable name="container" select="ancestor::*:div[@subtype=$container_type]" />
        <xsl:copy>
            <xsl:apply-templates  select="@*"/>
            <xsl:if test="$renumber_div">
                <xsl:variable name="seq" select="$container//*:div" />
                <xsl:attribute name="n" select="index-of($seq, current())"/>
            </xsl:if>
            <xsl:apply-templates  select="node()|comment()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template match="node()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="./@*"/>
            <xsl:apply-templates  select="node()|comment()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>