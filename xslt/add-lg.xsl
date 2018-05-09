<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    >
    <xsl:output method="xml" encoding="UTF-8" exclude-result-prefixes="#all"/>
    <xsl:key name="kitemByFirstSibling"
        match="*:l[preceding-sibling::*[1][self::*:l]]"
        use="generate-id(preceding-sibling::*:l
        [not(preceding-sibling::*[1][self::*:l])][1])"/>
    <xsl:template match="@*|node()" name="identity">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*[not(self::lg)]/*:l"/>
    <xsl:template match="*[not(self::lg)]
        /*:l[not(preceding-sibling::*[1][self::*:l])]"
        priority="1">
        <lg>
            <xsl:for-each select=".|key('kitemByFirstSibling',generate-id())">
                <xsl:call-template name="identity"/>
            </xsl:for-each>
        </lg>
    </xsl:template>
    <xsl:template match="*:l/*:l[not(position()=1)]"/>
</xsl:stylesheet>
