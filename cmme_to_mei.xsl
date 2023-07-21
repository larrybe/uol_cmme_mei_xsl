<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" xmlns="http://www.music-encoding.org/ns/mei" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cmme="http://www.cmme.org" exclude-result-prefixes="cmme">
<xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8" />

<xsl:template match="cmme:Piece">
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
        <xsl:apply-templates select="cmme:GeneralData" />
      </meiHead>
      <!-- The music element contains the music data in mei. The equivalent in CMME is MusicSection -->
      <music>
        <body>
          <mdiv>
            <xsl:apply-templates select="cmme:MusicSection" />
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
      <xsl:if test="cmme:Notes">
      <annot label="Notes"><xsl:value-of select="cmme:Notes" /></annot>
      </xsl:if>
    </notesStmt>
    </xsl:if>
    <sourceDesc>
      <source>
        <bibl>
          <identifier label="electronic" type="URI">https://www.cmme.org/database</identifier>
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

<xsl:template match="cmme:MusicSection">
  <score>
    <xsl:if test="cmme:Editorial or cmme:PrincipalSource">
      <app>
        <rdg>
          <xsl:if test="cmme:Editorial">
            <annot label="CMME-Editorial"><xsl:value-of select="cmme:Editorial" /></annot>
          </xsl:if>
          <xsl:if test="cmme:PrincipalSource">
            <!-- TODO: SourceInfo -->
          </xsl:if>
        </rdg>
      </app>
    </xsl:if>
    <scoreDef>
      <!-- Template to render the title and composer in the score viewer -->
      <xsl:call-template name="renderTitle" />
      <!-- Template that defines the staffs -->
      <xsl:call-template name="StaffDefinition" />
    </scoreDef>
    <!-- Template for the music notation data -->
    <xsl:call-template name="MusicSectionData" />
  </score>
</xsl:template>

<xsl:template name="renderTitle">
  <!-- Renders the title and name of composer at the top of the score viewer -->
  <pgHead>
    <rend halign="center" valign="middle" fontweight="bold" fontsize="100%"><xsl:value-of select="//cmme:GeneralData/cmme:Title" /></rend>
    <rend halign="center" valign="middle" fontweight="bold" fontsize="150%"><xsl:value-of select="//cmme:GeneralData/cmme:Composer" /></rend>
  </pgHead>
</xsl:template>

<xsl:template name="StaffDefinition">
  <!-- Define staffs -->
  <staffGrp>
    <xsl:for-each select="cmme:MensuralMusic/cmme:Voice/cmme:EventList">
      <staffDef>
        <xsl:attribute name="n">
          <xsl:value-of select="position()" />
        </xsl:attribute>
        <xsl:attribute name="notationtype">
          <xsl:text>mensural</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="lines">
          <xsl:text>5</xsl:text>
        </xsl:attribute>
      </staffDef>
    </xsl:for-each>
  </staffGrp>
</xsl:template>

<xsl:template match="cmme:Clef">
  <clef>
    <xsl:call-template name="ClefData" />
  </clef>
</xsl:template>

<xsl:template name="ClefData">
  <xsl:attribute name="shape">
    <xsl:value-of select="cmme:Appearance"/>
  </xsl:attribute>
  <!-- Investigate the staffLoc thing -->
  <xsl:attribute name="line">
    <xsl:value-of select="cmme:StaffLoc"/>
  </xsl:attribute>
</xsl:template>

<xsl:template name="MusicSectionData">
  <section>
    <xsl:apply-templates select="cmme:MensuralMusic/cmme:Voice" />
</section>
</xsl:template>

<xsl:template match="cmme:MensuralMusic/cmme:Voice">
  <xsl:call-template name="SingleVoiceMensuralSectionData" />
</xsl:template>

<xsl:template name="SingleVoiceMensuralSectionData">
  <xsl:for-each select="cmme:EventList">
      <staff>
        <xsl:attribute name="n">
          <xsl:value-of select="position()" />
        </xsl:attribute>
        <layer>
          <xsl:apply-templates select="cmme:Note|cmme:Mensuration|cmme:Rest|cmme:Dot" />
        </layer>
      </staff>
  </xsl:for-each>
</xsl:template>

<xsl:template match="cmme:Mensuration">
  <mensur>
    <xsl:call-template name="MensurationData" />
  </mensur>
</xsl:template>

<xsl:template name="MensurationData">
  <xsl:attribute name="sign">
    <xsl:value-of select="cmme:Sign/cmme:MainSymbol" />
  </xsl:attribute>
  <xsl:if test="cmme:Sign/cmme:Orientation">
    <xsl:attribute name="orient">
      <xsl:value-of select="translate(cmme:Sign/cmme:Orientation, 'R', 'r')" />
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<!-- Template for the NoteData group in the CMME schema -->
<xsl:template match="cmme:Note">
  <note>
    <xsl:call-template name="NoteInfoData" />
    <xsl:call-template name="StaffPitchData" />
    <!-- TODO -->
    <xsl:if test="cmme:ModernAccidental">
      <xsl:call-template name="ModernAccidentalData" />
    </xsl:if>
    <!-- <xsl:if test="cmme:Lig">
      Lost data: Retrorsum
      <xsl:attribute name="lig">
        
      </xsl:attribute>
    </xsl:if> -->
  </note>
</xsl:template>

<!-- Template for dot data -->
<xsl:template match="cmme:Dot">
  <dot>
    <xsl:call-template name="DotData" />
  </dot>
</xsl:template>

<!-- Template for rest data -->
<xsl:template match="cmme:Rest">
  <rest>
    <xsl:call-template name="NoteInfoData" />
  </rest>
</xsl:template>

<xsl:template name="NoteInfoData">
  <xsl:attribute name="dur">
    <xsl:value-of select="lower-case(cmme:Type)" />
  </xsl:attribute>
  <xsl:attribute name="num">
    <xsl:value-of select="cmme:Length/cmme:Num" />
  </xsl:attribute>
  <xsl:attribute name="numbase">
    <xsl:value-of select="cmme:Length/cmme:Den" />
  </xsl:attribute>
</xsl:template>

<xsl:template name="StaffPitchData">
  <xsl:if test="cmme:StaffLoc">
    <xsl:attribute name="loc">
      <xsl:value-of select="cmme:StaffLoc" />
    </xsl:attribute>
  </xsl:if>
  <xsl:call-template name="Locus" />
</xsl:template>

<xsl:template name="DotData">
  <xsl:choose>
    <xsl:when test="cmme:StaffLoc">
      <xsl:attribute name="loc">
        <xsl:value-of select="cmme:StaffLoc" />
      </xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="ploc">
        <xsl:value-of select="lower-case(cmme:Pitch/cmme:LetterName)" />
      </xsl:attribute>
      <xsl:attribute name="oloc">
        <xsl:value-of select="cmme:Pitch/cmme:OctaveNum" />
      </xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Matches with Locus in the CMME schema 
    Contains the pitch letter and octave number
 -->
<xsl:template name="Locus">
  <xsl:attribute name="pname">
    <xsl:value-of select="lower-case(cmme:LetterName)" />
  </xsl:attribute>
  <xsl:attribute name="oct">
    <xsl:value-of select="cmme:OctaveNum" />
  </xsl:attribute>
</xsl:template>

<!-- TODO -->
<xsl:template name="ModernAccidentalData">

</xsl:template>

</xsl:stylesheet>