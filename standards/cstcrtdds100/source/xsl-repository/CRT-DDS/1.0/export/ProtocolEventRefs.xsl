<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:def="http://www.cdisc.org/ns/def/v1.0"
	xmlns="http://www.cdisc.org/ns/odm/v1.2">

	<xsl:template name="ProtocolEventRefs">
	
	   <xsl:param name="parentKey" />
       
       <xsl:for-each select="../ProtocolEventRefs[FK_MetaDataVersion = $parentKey]">      
       
         <xsl:element name="Protocol">
            <xsl:element name="StudyEventRef">
               <xsl:attribute name="Mandatory"><xsl:value-of select="Mandatory"/></xsl:attribute>
               <xsl:if test="string-length(normalize-space(OrderNumber)) &gt; 0">
                  <xsl:attribute name="OrderNumber"><xsl:value-of select="OrderNumber"/></xsl:attribute>
               </xsl:if>
               <xsl:attribute name="StudyEventOID"><xsl:value-of select="StudyEventOID"/></xsl:attribute> 
            </xsl:element>         
         </xsl:element>
        
       </xsl:for-each>
       	
  </xsl:template>
</xsl:stylesheet>