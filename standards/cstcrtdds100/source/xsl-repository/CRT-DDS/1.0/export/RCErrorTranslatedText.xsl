<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.cdisc.org/ns/odm/v1.2">

	<xsl:template name="RCErrorTranslatedText">

	  <xsl:param name="parentKey" />
      
       <xsl:if test="count(../RCErrorTranslatedText[FK_ItemRangeChecks = $parentKey]) != 0">
       
       <xsl:element name="ErrorMessage">
       
         <xsl:for-each select="../RCErrorTranslatedText[FK_ItemRangeChecks = $parentKey]">
       
          <xsl:element name="TranslatedText">
            <xsl:if test="string-length(normalize-space(lang)) &gt; 0">
                <xsl:attribute name="xml:lang"><xsl:value-of select="lang"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="TranslatedText"/>
          </xsl:element>
        
         </xsl:for-each>
      
       </xsl:element>
       
       </xsl:if>
        	
  </xsl:template>
</xsl:stylesheet>