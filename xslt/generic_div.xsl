<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output indent="yes"></xsl:output>
    <xsl:param name="lang" select="'lat'"/>
    <xsl:variable name="namespace">
        <xsl:choose>
            <xsl:when test="$lang eq 'lat'">latinLit</xsl:when>
            <xsl:otherwise>greekLit</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="node()|@*|comment()">
        <!-- Copy the current node -->
        <xsl:copy>
            <!-- Including any child nodes it has and any attributes -->
            <xsl:apply-templates select="node()|@*|comment()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="sourceDesc">
        <xsl:element name="sourceDesc">
            <xsl:apply-templates select="node()|@*|comment()" />
            
        </xsl:element>
    </xsl:template>
    <xsl:template match="revisionDesc">
        <xsl:element name="revisionDesc">
        <xsl:apply-templates select="node()|comment()" />
        <!--xsl:element name="revisionDesc">
            <xsl:element name="change">
                <xsl:attribute name="who" select="'gcrane'" />
                <xsl:attribute name="when" select="concat(.//date/text(), '-01-01')" />
                <xsl:value-of select=".//resp/text()"/>
            </xsl:element>
        </xsl:element-->
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="text">
        <xsl:element name="text">
            <xsl:attribute name="xml:lang"><xsl:value-of select="@lang"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@anchored">
        <xsl:attribute name="anchored" select="'true'" />
    </xsl:template>
    
    <xsl:template match="body">
        <xsl:element name="body">
            <xsl:element name="div">
                <xsl:attribute name="xml:lang" select="$lang" />
                <xsl:attribute name="type" select="'edition'" />
                <xsl:attribute name="n" select="concat('urn:cts:', $namespace, ':',  replace(tokenize(base-uri(.), '/')[last()], '.xml', ''))" />
                
                <xsl:apply-templates select="node()|comment()" />
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="encodingDesc">
        <encodingDesc>
            <refsDecl n="CTS">
                <cRefPattern n="section"
                    matchPattern="(\w+).(\w+)"
                    replacementPattern="#xpath(/tei:TEI/tei:text/tei:body/tei:div/tei:div[@n='$1']/tei:div[@n='$2'])">
                    <p>This pointer pattern extracts section</p>
                </cRefPattern>
                <cRefPattern n="chapter"
                    matchPattern="(\w+)"
                    replacementPattern="#xpath(/tei:TEI/tei:text/tei:body/tei:div/tei:div[@n='$1'])">
                    <p>This pointer pattern extracts chapter</p>
                </cRefPattern>
            </refsDecl>
            <xsl:apply-templates select="refsDecl"/>
            <xsl:apply-templates select="comment()"/>
            <xsl:apply-templates select="node()[local-name(.) != 'refsDecl']"/>
        </encodingDesc>
    </xsl:template>
    <xsl:template match="refsDecl[@doctype]">
        <xsl:element name="refsDecl">
            <xsl:attribute name="n" select="@doctype" />
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    <xsl:template match="language">
        <xsl:element name="language">
            <xsl:choose>
                <xsl:when test="@ident = 'la'"><xsl:attribute name="ident" select="'lat'"/></xsl:when>
                <xsl:when test="@ident = 'en'"><xsl:attribute name="ident" select="'eng'"/></xsl:when>
                <xsl:when test="@ident = 'fr'"><xsl:attribute name="ident" select="'fre'"/></xsl:when>
                <xsl:when test="@ident = 'it'"><xsl:attribute name="ident" select="'ita'"/></xsl:when>
                <xsl:when test="@ident = 'de'"><xsl:attribute name="ident" select="'ger'"/></xsl:when>
                <xsl:when test="@ident = 'greek'"><xsl:attribute name="ident" select="'grc'"/></xsl:when>
                <xsl:otherwise><xsl:attribute name="ident" select="@ident"/></xsl:otherwise>
            </xsl:choose>
          <xsl:apply-templates select="node()|comment()"/>
        </xsl:element>
    </xsl:template>
    
    <!-- this needs work before general use because if there is no who attribute we end up with invalid data 
    <xsl:template match="sp">
        <xsl:element name="sp">
          <xsl:attribute name="who" select="concat('#', @who)" />
          <xsl:apply-templates select="node()|comment()"/>
        </xsl:element>
    </xsl:template>
    -->
    
    <xsl:template match="state">
        <xsl:element name="refState">
            <xsl:apply-templates select="@*"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="div1|div2|div3|div">
        <xsl:element name="div">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="subtype" select="@type"/>
            <xsl:attribute name="type">textpart</xsl:attribute>
            <xsl:apply-templates select="node()|comment()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="pb[@id]">
        <xsl:element name="pb">
            <xsl:attribute name="n" select="@id" />
        </xsl:element>
    </xsl:template>
    <xsl:template match="abbr[@expan]">
        <xsl:copy>
            <xsl:apply-templates select="node()|comment()" />
            <xsl:element name="expan"><xsl:element name="ex"><xsl:value-of select="@expan"/></xsl:element></xsl:element>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="gap">
        <xsl:element name="gap">
           <xsl:choose>
               <xsl:when test="parent::node()/text() = '*'">
                   <xsl:attribute name="reason" select="'lost'" />
               </xsl:when>
               <xsl:otherwise>
                   <xsl:attribute name="reason" select="'omitted'" />
               </xsl:otherwise>
           </xsl:choose>
         <xsl:apply-templates select="node()|@*|comment()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="TEI.2">
        <xsl:element name="TEI">
            <xsl:apply-templates select="node()|@*|comment()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="teiHeader">
        <xsl:element name="teiHeader">
            <xsl:attribute name="type" select="'text'"/>
            <xsl:apply-templates select="node()|comment()"/>
            <revisionDesc>
                <change when="2016-11-20" who="Thibault Clérice">CapiTainS and Epidoc</change>
            </revisionDesc>
        </xsl:element>
    </xsl:template>
    <xsl:template match="castList">
        <listPerson>
            <xsl:apply-templates select="node()|comment()"/>
        </listPerson>
    </xsl:template>
    <xsl:template match="castItem">
        <person>
            <persName xml:lang="eng"><xsl:value-of select="role/text()"/><xsl:apply-templates select="role/note" /><roleName><xsl:value-of select="roleDesc/text()"/><xsl:apply-templates select="roleDesc/note" /></roleName></persName>
        </person>
    </xsl:template>
    <xsl:template match="castGroup">
        <listPerson rend="castGroup">
            <xsl:apply-templates />
        </listPerson>
    </xsl:template>
    <xsl:template match="lemma[@targOrder]">
        <xsl:element name="q"><xsl:apply-templates/></xsl:element>
    </xsl:template>
    <xsl:template match="milestone/@unit">
        <xsl:attribute name="unit" select="." />
    </xsl:template>
    <xsl:template match="note/@id">
        <xsl:attribute name="n" select="." />
    </xsl:template>
    <xsl:template match="revisionDesc">
        <xsl:element name="revisionDesc">
            <xsl:value-of select=".//item"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="sourceDesc/p">
        <list><item>OCR cleanup</item></list>
    </xsl:template>
    <xsl:template match="@lang">
        <xsl:choose>
            <xsl:when test=". = 'la'"><xsl:attribute name="xml:lang" select="'lat'"/></xsl:when>
            <xsl:when test=". = 'en'"><xsl:attribute name="xml:lang" select="'eng'"/></xsl:when>
            <xsl:when test=". = 'fr'"><xsl:attribute name="xml:lang" select="'fre'"/></xsl:when>
            <xsl:when test=". = 'it'"><xsl:attribute name="xml:lang" select="'ita'"/></xsl:when>
            <xsl:when test=". = 'de'"><xsl:attribute name="xml:lang" select="'ger'"/></xsl:when>
            <xsl:otherwise><xsl:copy/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="opener">
        <label rend="opener"><xsl:apply-templates /></label>
    </xsl:template>
    
</xsl:stylesheet>