<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:odm="http://www.cdisc.org/ns/odm/v1.3">

	<xsl:template name="ItemRole">	
    
    <xsl:for-each select=".">

      <xsl:element name="ItemRole">
         <xsl:element name="Name"><xsl:value-of select="."/></xsl:element> 
         <xsl:element name="FK_ItemDefs"><xsl:value-of select="../@OID"/></xsl:element>
      </xsl:element>
      
    </xsl:for-each>
       	
  </xsl:template>
</xsl:stylesheet>