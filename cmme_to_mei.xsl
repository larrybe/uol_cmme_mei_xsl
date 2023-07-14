<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" xmlns="http://www.music-encoding.org/ns/mei" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cmme="http://www.cmme.org" exclude-result-prefixes="cmme">
<xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8" />

<xsl:template match="/">
<xsl:text>&#xa;</xsl:text>
<xsl:processing-instruction name="xml-model">
href="https://music-encoding.org/schema/4.0.1/mei-Mensural.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
<xsl:text>&#xa;</xsl:text>
<xsl:processing-instruction name="xml-model">
href="https://music-encoding.org/schema/4.0.1/mei-Mensural.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
<!-- Start of the mei file -->
    <mei  meiversion="4.0.1">
      <!-- meiHead contains the metadata of the music file. The equivalent in CMME is GeneralData  -->
      <meiHead>
        <!-- Transform the contents in the GeneralData element in the CMME file into the meiHead element  -->
        <xsl:apply-templates select="//cmme:GeneralData" />
      </meiHead>
      <!-- The music element contains the music data in mei. The equivalent in CMME is MusicSection -->
      <music>
        <body>
          <mdiv>
            <score>
            <scoreDef>
              <pgHead>
                <rend halign="center" valign="middle" fontweight="bold" fontsize="100%"><xsl:value-of select="//cmme:GeneralData/cmme:Title" /></rend>
                <rend halign="center" valign="middle" fontweight="bold" fontsize="150%"><xsl:value-of select="//cmme:GeneralData/cmme:Composer" /></rend>
              </pgHead>
            </scoreDef>
            </score>
          </mdiv>
        </body>
      </music>
    </mei>
</xsl:template>

<xsl:template match="cmme:GeneralData">
  <fileDesc>
    <titleStmt>
      <title><xsl:value-of select="cmme:Title" /></title>
      <composer><xsl:value-of select="cmme:Composer" /></composer>
      <editor><xsl:value-of select="cmme:Editor" /></editor>
      <respStmt>
        <resp>Originally encoded by</resp>
        <corpName role="encoder">The CMME Project</corpName>
      </respStmt>
    </titleStmt>
    <!-- Nope -->
    <pubStmt></pubStmt>
    <xsl:if test="cmme:PublicNotes or cmme:Notes">
    <notesStmt>
      <xsl:if test="cmme:PublicNotes">
        <annot label="PublicNotes"><xsl:value-of select="cmme:PublicNotes" /></annot>
      </xsl:if>
      <!-- Nope -->
      <xsl:if test="cmme:Notes">
      <annot label="Notes"><xsl:value-of select="cmme:Notes" /></annot>
      </xsl:if>
    </notesStmt>
    </xsl:if>
    <sourceDesc>
      <source>
        <bibl>
          <identifier label="electronic" type="URI">https://www.cmme.org/database</identifier>
          <title><xsl:value-of select="tokenize(base-uri(.), '/')[last()]" /></title>
          <editor><xsl:value-of select="cmme:Editor" /></editor>
        </bibl>
      </source>
    </sourceDesc>
  </fileDesc>
  <encodingDesc>
    <appInfo>
      <application>
        <name>CMME to MEI Converter</name>
      </application>
    </appInfo>
  </encodingDesc>
  <xsl:if test="cmme:Incipit">
  <workList>
    <work>
      <xsl:if test="cmme:Incipit">
        <incip>
          <incipText><xsl:value-of select="cmme:Incipit" /></incipText>
        </incip>
      </xsl:if>
    </work>
  </workList>
  </xsl:if>
  <extMeta></extMeta>
</xsl:template>


</xsl:stylesheet>