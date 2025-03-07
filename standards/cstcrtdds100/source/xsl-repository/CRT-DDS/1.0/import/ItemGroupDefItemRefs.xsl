<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:odm="http://www.cdisc.org/ns/odm/v1.2"
	xmlns:def="http://www.cdisc.org/ns/def/v1.0">

	<xsl:template name="ItemGroupDefItemRefs">	
    
    <xsl:for-each select=".">

      <xsl:element name="ItemGroupDefItemRefs">
         <xsl:element name="ItemOID"><xsl:value-of select="@ItemOID"/></xsl:element> 
         <xsl:element name="OrderNumber"><xsl:value-of select="@OrderNumber"/></xsl:element>  
         <xsl:element name="Mandatory"><xsl:value-of select="@Mandatory"/></xsl:element> 
         <xsl:element name="KeySequence"><xsl:value-of select="@KeySequence"/></xsl:element> 
         <xsl:element name="ImputationMethodOID"><xsl:value-of select="@ImputationMethodOID"/></xsl:element>
         <xsl:element name="Role"><xsl:value-of select="@Role"/></xsl:element>
         <xsl:element name="RoleCodeListOID"><xsl:value-of select="@RoleCodeListOID"/></xsl:element>
         <xsl:element name="FK_ItemGroupDefs"><xsl:value-of select="../@OID"/></xsl:element>
      
      </xsl:element>
      
    </xsl:for-each>
       	
  </xsl:template>
</xsl:stylesheet>