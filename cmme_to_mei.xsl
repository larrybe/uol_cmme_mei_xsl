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
    <mei meiversion="4.0.1">
      <!-- meiHead contains the metadata of the music file. The equivalent in CMME is GeneralData  -->
      <meiHead>
        <!-- Transform the contents in the GeneralData element in the CMME file into the meiHead element  -->
        <xsl:apply-templates select="cmme:GeneralData" />
      </meiHead>
      <!-- The music element contains the music data in mei. The equivalent in CMME is MusicSection -->
      <music>
        <body>
          <mdiv>
            <score>
              <!-- Using the cmme VoiceData for the scoreDef element -->
              <xsl:apply-templates select="cmme:VoiceData" />
              <!-- -->
              <xsl:apply-templates select="cmme:MusicSection" />
            </score>
          </mdiv>
        </body>
      </music>
    </mei>
</xsl:template>

<!-- cmme:GeneralData/Metadata -->
<!-- Contents in meiHead -->
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
    <!-- pubStmt is required for validation -->
    <pubStmt></pubStmt>
    <xsl:if test="cmme:PublicNotes or cmme:Notes">
      <notesStmt>
        <xsl:apply-templates select="cmme:PublicNotes" />
        <xsl:apply-templates select="cmme:Notes" />
      </notesStmt>
    </xsl:if>
    <sourceDesc>
      <source>
        <bibl>
          <identifier label="electronic" type="URI">https://www.cmme.org/database</identifier>
          <xsl:apply-templates select="cmme:Editor" />
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
  <!-- INVESTIGATE -->
  <xsl:if test="cmme:Incipit or cmme:VariantVersion">
    <workList>
      <!-- Incipit in CMME -->
      <xsl:apply-templates select="cmme:Incipit" />
      <!-- VariantVersions in CMME -->  
      <xsl:comment>
        VariantVersion(s) in CMME
      </xsl:comment>  
      <xsl:apply-templates select="cmme:VariantVersion" />
    </workList>
  </xsl:if>
</xsl:template>

<xsl:template match="cmme:Incipit">
    <xsl:comment>
    Incipit in CMME
    </xsl:comment>  
  <work>
    <title><xsl:value-of select="../cmme:Title" /></title>
    <incip label="Incipit">
      <incipText>
        <p><xsl:value-of select="." /></p>
      </incipText>
    </incip>
  </work>
</xsl:template>

<xsl:template match="cmme:VariantVersion">
  <xsl:comment>A VariantVersion
      </xsl:comment>
  <work>
    <title><xsl:value-of select="../cmme:Title" /></title>
    <biblList>
      <bibl>
        <!-- ID -->
        <identifier><xsl:value-of select="cmme:ID" /></identifier>
        <xsl:apply-templates select="cmme:Source" />
        <xsl:apply-templates select="cmme:Editor" />
      </bibl>
      </biblList>
      <!-- Description -->
      <xsl:if test="cmme:Description">
        <notesStmt label="description">
          <annot><xsl:value-of select="cmme:Description" /></annot>
        </notesStmt>
      </xsl:if>
      <!-- Extra CMME metaData that MEI does not have equivalent elements for. -->
      <!-- Bug in the MEI schema prevents the document from validating if the extMeta element is used. -->
      <!-- So the data is preserved in comments instead. -->
        <xsl:if test="cmme:Default or cmme:MissingVoices">
        <extMeta>
          <xsl:comment>

            <xsl:text> 
              A Bug in MEI prevents the document from validating if there are other elements in extMeta. 
            </xsl:text>
          </xsl:comment>
          <xsl:comment>
            <xsl:text> 
              The CMME data is preserved in the commented xml elements below.
            </xsl:text>
          </xsl:comment>
          <xsl:comment>
            <xsl:text>
              Remove the comment tags to have it in xml.
            </xsl:text>
          <xsl:if test="cmme:Default">
              &lt;Default /&gt;
          </xsl:if>
          <xsl:if test="cmme:MissingVoices">
            &lt;MissingVoices&gt;
            <xsl:for-each select="cmme:MissingVoices/cmme:VoiceNum">
              &lt;VoiceNum&gt;<xsl:value-of select="." />&lt;/VoiceNum&gt;
            </xsl:for-each>
            &lt;/MissingVoices&gt;
          </xsl:if>
        </xsl:comment>
        </extMeta>
      </xsl:if>
  </work>
</xsl:template>

<xsl:template match="cmme:PublicNotes">
  <annot label="PublicNotes">
    <xsl:value-of select="." />
  </annot>
</xsl:template>

<xsl:template match="cmme:Notes">
  <annot label="Notes">
    <xsl:value-of select="." />
  </annot>
</xsl:template>

<xsl:template match="cmme:Editor">
  <editor>
    <xsl:value-of select="." />
  </editor>
</xsl:template>

<xsl:template match="cmme:Source">
  <edition label="source">
    <xsl:call-template name="SourceInfo" />
  </edition>
</xsl:template>
<!-- / cmme:GeneralData/Metadata -->


<!-- cmme:VoiceData -->
<xsl:template match="cmme:VoiceData">
  <scoreDef>
    <xsl:call-template name="renderTitle" />
    <xsl:call-template name="StaffDefinition" />
  </scoreDef>
</xsl:template>

<!-- Renders the title and name of composer -->
<xsl:template name="renderTitle">
  <pgHead>
    <rend halign="center" valign="middle" fontweight="bold" fontsize="100%"><xsl:value-of select="//cmme:GeneralData/cmme:Title" /></rend>
    <rend halign="center" valign="middle" fontweight="bold" fontsize="150%"><xsl:value-of select="//cmme:GeneralData/cmme:Composer" /></rend>
  </pgHead>
</xsl:template>

<!-- Defines the musical staffs -->
<xsl:template name="StaffDefinition">
  <!-- Define staffs -->
  <staffGrp>
    <xsl:for-each select="cmme:Voice">
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
        <label>
          <xsl:value-of select="cmme:Name" />
        </label>
      </staffDef>
    </xsl:for-each>
  </staffGrp>
</xsl:template>
<!-- /cmme:VoiceData -->


<!-- MusicSection -->
<xsl:template match="cmme:MusicSection">
    <xsl:if test="cmme:Editorial or cmme:PrincipalSource">
      <annot>
        <xsl:apply-templates select="../cmme:MusicSection/cmme:Editorial" />
        <xsl:apply-templates select="cmme:PrincipalSource" />
      </annot>
    </xsl:if>
    <!-- Template for the music notation data -->
    <xsl:call-template name="MusicSectionData" />
</xsl:template>

<xsl:template match="cmme:MusicSection/cmme:Editorial">
  <p label="Editorial">
    <xsl:value-of select="." />
  </p>
</xsl:template>

<xsl:template match="cmme:PrincipalSource">
  <!-- SourceInfo -->
  <bibl label="PrincipalSource">
    <xsl:call-template name="SourceInfo" />
  </bibl>
</xsl:template>

<xsl:template name="SourceInfo">
  <name><xsl:value-of select="cmme:Name" /></name>
  <identifier><xsl:value-of select="cmme:ID" /></identifier>
</xsl:template>

<xsl:template name="MusicSectionData">
  <section>
    <xsl:apply-templates select="cmme:MensuralMusic" />
    <xsl:apply-templates select="cmme:Plainchant" />
    <xsl:apply-templates select="cmme:Text" />
</section>
</xsl:template>

<!-- MensuralMusic -->
<xsl:template match="cmme:MensuralMusic">
  <xsl:call-template name="MensuralMusicData" />
</xsl:template>

<xsl:template name="MensuralMusicData">
  <!-- NumVoices -->
  <!-- basecoloration -->
  <xsl:apply-templates select="cmme:TacetInstruction" />
  <xsl:apply-templates select="../cmme:MensuralMusic/cmme:Voice" />
</xsl:template>

<xsl:template match="cmme:TacetInstruction">
  
</xsl:template>

<xsl:template match="cmme:MensuralMusic/cmme:Voice">
  <xsl:call-template name="SingleVoiceSectionData" />
</xsl:template>

<xsl:template name="SingleVoiceSectionData">
  <!-- VoiceNum -->
  <!-- CanonResolutio (SVMSD) -->
  <!-- MissingVersionID -->
  <xsl:apply-templates select="cmme:EventList" />
</xsl:template>

<xsl:template match="cmme:EventList">
  <staff>
    <xsl:attribute name="n">
      <xsl:value-of select="../cmme:VoiceNum" />
    </xsl:attribute>
    <xsl:call-template name="EventListData" />
  </staff>
</xsl:template>

<xsl:template name="EventListData">
  <layer>
    <xsl:call-template name="SingleOrMultiEventData" />
    <xsl:apply-templates select="cmme:VariantReadings" />
    <xsl:apply-templates select="cmme:EditorialData" />
  </layer>
</xsl:template>

<xsl:template name="SingleOrMultiEventData">
    <xsl:call-template name="SingleEventData" />
    <xsl:apply-templates select="cmme:MultiEvent" />
</xsl:template>

<xsl:template name="SingleEventData">
    <xsl:apply-templates select="*" />
</xsl:template>
<!-- /MensuralMusic -->

<!-- Plainchant -->
<xsl:template match="cmme:Plainchant">
  <xsl:call-template name="PlainchantSectionData" />
</xsl:template>

<xsl:template name="PlainchantSectionData">
  <!-- NumVoices -->
  <!-- BaseColoration -->
  <!-- TacetInstruction -->
  <xsl:apply-templates select="../cmme:Plainchant/cmme:Voice" />
  <!-- TextSectionData -->
</xsl:template>

<xsl:template match="cmme:Plainchant/cmme:Voice">
  <xsl:call-template name="SingleVoiceChantSectionData" />
</xsl:template>

<xsl:template name="SingleVoiceChantSectionData">
  <!-- VoiceNum -->
  <!-- CanonResolutio -->
  <!-- MissingVersionID -->
  <xsl:apply-templates select="cmme:EventList" />
</xsl:template>
<!-- /Plainchant -->

<!-- Text -->
<xsl:template match="cmme:Text">
  <div>
    <xsl:apply-templates select="cmme:Content" />
  </div>
</xsl:template>

<xsl:template match="cmme:Content">
  <p><xsl:value-of select="." /></p>
</xsl:template>

<!-- events representing original notational elements -->

<!-- CLEF -->
<xsl:template match="cmme:Clef">
  <xsl:choose>
    <xsl:when test="matches(cmme:Appearance, 'C|F|G|Frnd|Fsqr|Gamma|MODERNG|MODERNG8|MODERNF|MODERNC')">
      <xsl:call-template name="Clef" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="KeySignature" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="Clef">
  <!-- Frnd, Fsqr and Gamma clefs are not supported in CMME.
      The result document will have a comment informing of this  -->
    <xsl:if test="matches(cmme:Appearance, 'Frnd|Fsqr|Gamma')">
      <xsl:text>&#xa;</xsl:text>
      <xsl:comment> Incompatibility: In cmme this <xsl:value-of select="cmme:Pitch/cmme:LetterName" /> clef appears as a <xsl:value-of select="cmme:Appearance" /> clef: &lt;Appearance&gt;<xsl:value-of select="cmme:Appearance" />&lt;/Appearance&gt; </xsl:comment><xsl:text>&#xa;</xsl:text>
      &#xa;
      <xsl:comment>&#xa;</xsl:comment>
    </xsl:if>

    <clef>
      <xsl:call-template name="ClefData" />
    </clef>
</xsl:template>

<xsl:template name="ClefData">
  <xsl:apply-templates select="@ID" />
  <xsl:attribute name="shape">
    <xsl:value-of select="cmme:Pitch/cmme:LetterName"/>
  </xsl:attribute>
  <xsl:attribute name="line">
    <xsl:value-of select="ceiling(cmme:StaffLoc div 2)"/>
  </xsl:attribute>
  <xsl:attribute name="oct">
    <xsl:value-of select="cmme:Pitch/cmme:OctaveNum" />
  </xsl:attribute>
  <!-- <xsl:call-template name="EventAttributes" /> -->
</xsl:template>

<xsl:template name="KeySignature">
    <accid>
      <xsl:call-template name="KeySignatureData" />
    </accid>
</xsl:template>

<xsl:template name="KeySignatureData">
  <xsl:attribute name="accid">
    <xsl:choose>
      <xsl:when test="cmme:Appearance='Bmol'">
        <xsl:text>f</xsl:text>
      </xsl:when>
      <xsl:when test="cmme:Appearance='BmolDouble'">
        <xsl:text>ff</xsl:text>
      </xsl:when>
      <xsl:when test="cmme:Appearance='Bqua'">
        <xsl:text>n</xsl:text>
      </xsl:when>
      <xsl:when test="cmme:Appearance='Diesis'">
        <xsl:text>x</xsl:text>
      </xsl:when>
      <xsl:when test="cmme:Appearance='Fis'">
        <xsl:text><!-- TODO --></xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="loc">
    <xsl:value-of select="cmme:StaffLoc - 1" />
  </xsl:attribute>
  <xsl:attribute name="ploc">
    <xsl:value-of select="lower-case(cmme:Pitch/cmme:LetterName)" />
  </xsl:attribute>
  <xsl:attribute name="oloc">
    <xsl:value-of select="cmme:Pitch/cmme:OctaveNum" />
  </xsl:attribute>
</xsl:template>
<!-- /Clef -->

<!-- MENSURATION -->
<xsl:template match="cmme:Mensuration">
  <mensur>
    <xsl:call-template name="MensurationData" />
  </mensur>
</xsl:template>

<xsl:template name="MensurationData">
  <xsl:apply-templates select="@ID" />
  <xsl:apply-templates select="cmme:Sign" />
  <xsl:apply-templates select="cmme:Number" />
  <xsl:apply-templates select="cmme:StaffLoc" />
  <xsl:apply-templates select="../cmme:Mensuration/cmme:Orientation" />
  <!-- TODO: Small -->
  <xsl:apply-templates select="cmme:MensInfo" />
  <!-- TODO: NoScoreEffect -->
  <!-- <xsl:call-template name="EventAttributes" /> -->
</xsl:template>

  <!-- Sign -->
<xsl:template match="cmme:Sign">
  <xsl:apply-templates select="cmme:MainSymbol" />
  <xsl:apply-templates select="../cmme:Sign/cmme:Orientation" />
  <xsl:apply-templates select="cmme:Strokes" />
  <xsl:call-template name="SignDot" />
</xsl:template>

<xsl:template match="cmme:MainSymbol">
  <xsl:attribute name="sign">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:Sign/cmme:Orientation">
  <xsl:attribute name="orient">
    <xsl:value-of select="translate(., 'R', 'r')" />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:Strokes">
  <xsl:attribute name="slash">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>

<xsl:template name="SignDot">
  <xsl:attribute name="dot">
    <xsl:choose>
      <xsl:when test="cmme:Dot">
        <xsl:text>true</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>false</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>
  <!-- /Sign -->

<xsl:template match="cmme:Number">
  <xsl:apply-templates select="cmme:Num" />
  <xsl:apply-templates select="cmme:Den" />
</xsl:template>

<xsl:template match="cmme:Num">
  <xsl:attribute name="num">
    <xsl:value-of select="."></xsl:value-of>
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:Den">
  <xsl:if test=".>0">
    <xsl:attribute name="numbase">
      <xsl:value-of select="."></xsl:value-of>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template match="cmme:StaffLoc">
  <xsl:attribute name="loc">
    <xsl:value-of select=". - 1" />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:Mensuration/cmme:Orientation">
    <xsl:attribute name="form">
      <xsl:value-of select="lower-case(.)" />
    </xsl:attribute>
</xsl:template>

<!-- TODO: Small -->

<xsl:template match="cmme:MensInfo">
  <xsl:apply-templates select="cmme:Prolatio" />
  <xsl:apply-templates select="cmme:Tempus" />
  <xsl:apply-templates select="cmme:ModusMinor" />
  <xsl:apply-templates select="cmme:ModusMaior" />
  <xsl:apply-templates select="cmme:TempoChange" />
</xsl:template>

<xsl:template match="cmme:Prolatio">
  <xsl:attribute name="prolatio">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:Tempus">
  <xsl:attribute name="tempus">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:ModusMinor">
  <xsl:attribute name="modusminor">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:ModusMaior">
  <xsl:attribute name="modusmaior">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:TempoChange">
  <xsl:attribute name="num">
    <xsl:value-of select="cmme:Num"></xsl:value-of>
  </xsl:attribute>
    <xsl:attribute name="numbase">
    <xsl:value-of select="cmme:Den"></xsl:value-of>
  </xsl:attribute>
</xsl:template>
<!-- /Mensuration -->


<!-- REST -->
<xsl:template match="cmme:Rest">
  <rest>
    <xsl:call-template name="RestData" />
  </rest>
</xsl:template>

<xsl:template name="RestData">
  <xsl:apply-templates select="@ID" />
  <xsl:call-template name="NoteInfoData" />
  <!-- BottomStaffLine -->
  <xsl:apply-templates select="cmme:NumSpaces" />
  <xsl:apply-templates select="cmme:Corona" />
  <!-- Signum --><!-- /SignumData -->
  <!-- <xsl:call-template name="EventAttributes" /> -->
</xsl:template>

<xsl:template match="cmme:NumSpaces">
  <xsl:if test=". > 0">
    <xsl:attribute name="spaces">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<!-- /Rest -->


<!-- NOTE -->
<xsl:template match="cmme:Note">
  <note>
    <xsl:call-template name="NoteData" />
  </note>
</xsl:template>

  <!-- NoteData -->
<xsl:template name="NoteData">
  <xsl:apply-templates select="@ID" />
  <xsl:call-template name="NoteInfoData" />
  <xsl:call-template name="StaffPitchData" />
  <!-- TODO ModernAccidental -->
  <xsl:apply-templates select="cmme:ModernAccidental" />
  <!-- Flagged -->
  <xsl:apply-templates select="cmme:Lig" />
  <xsl:apply-templates select="cmme:Tie" />
  <xsl:apply-templates select="cmme:Stem" />
  <!-- HalfColoration -->
  <xsl:apply-templates select="cmme:Corona" />
  <xsl:apply-templates select="cmme:Signum" />
  <xsl:apply-templates select="cmme:ModernText" />
  <!-- <xsl:call-template name="EventAttributes" /> -->
</xsl:template>


<xsl:template name="NoteInfoData">
  <xsl:apply-templates select="cmme:Type" />
  <xsl:apply-templates select="cmme:Length" />
</xsl:template>

<xsl:template match="cmme:Type">
  <xsl:attribute name="dur">
    <xsl:value-of select="lower-case(.)" />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:Length">
  <xsl:call-template name="ProportionData" />
</xsl:template>

  <!-- Stem -->
<xsl:template match="cmme:Stem">
  <xsl:apply-templates select="cmme:Dir" />
  <xsl:apply-templates select="cmme:Side" />
</xsl:template>

<xsl:template match="cmme:Dir">
  <xsl:attribute name="stem.dir">
    <xsl:choose>
      <xsl:when test=".='Barline'">
        <!-- Incompatibility: Barline stem direction not available in MEI. -->
        <xsl:text>down</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="lower-case(.)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:Side">
  <xsl:attribute name="stem.pos">
    <xsl:value-of select="lower-case(.)" />
  </xsl:attribute>
</xsl:template>
  <!-- /Stem -->

  <!-- Corona/fermata -->
  <!--
    NOTE: MEI has a fermata attribute that is similar to corona in CMME. 
    However, the fermata attribute is not supported by the MEI mensural.
    The conversion code is commented out below should an update 
    to the schema support it.
  -->
  <!-- 
<xsl:template match="cmme:Corona">
  <xsl:attribute name="fermata">
       <xsl:text>above</xsl:text>
  </xsl:attribute>
</xsl:template>
-->
<!-- /Corona -->

<!-- Signum -->
<xsl:template match="cmme:Signum">
  <xsl:apply-templates select="cmme:Offset" />
  <xsl:apply-templates select="../cmme:Signum/cmme:Orientation" />
  <xsl:apply-templates select="cmme:Side" />
</xsl:template>

<xsl:template match="cmme:Offset">
</xsl:template>

<xsl:template match="cmme:Signum/cmme:Orientation">
</xsl:template>

<xsl:template match="cmme:Side">
  <xsl:attribute name="stem.dir">
    <xsl:value-of select="lower-case(.)" />
  </xsl:attribute>
</xsl:template>
<!-- /Signum -->

<!-- ModernText -->
<xsl:template match="cmme:ModernText">
  <verse>
    <syl>
      <xsl:value-of select="cmme:Syllable" />
    </syl>
  </verse>
</xsl:template>
<!-- /ModernText -->


<!-- Dot -->
<xsl:template match="cmme:Dot">
  <dot>
    <xsl:call-template name="DotData" />
  </dot>
</xsl:template>

<xsl:template name="DotData">
  <xsl:apply-templates select="@ID" />
  <xsl:apply-templates select="../cmme:Dot/cmme:Pitch" />
  <xsl:apply-templates select="../cmme:Dot/cmme:StaffLoc" />
  <!-- RelativeStaffLoc -->
  <!-- NoteEventID -->
  <!-- <xsl:call-template name="EventAttributes" /> -->
</xsl:template>

<xsl:template match="cmme:Dot/cmme:Pitch">
  <!-- PITCH -->
  <xsl:attribute name="ploc">
    <xsl:value-of select="lower-case(cmme:LetterName)" />
  </xsl:attribute>
  <xsl:attribute name="oloc">
    <xsl:value-of select="cmme:OctaveNum" />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:Dot/cmme:StaffLoc">
<!-- STAFFLOC -->
  <xsl:attribute name="loc">
    <xsl:value-of select=". - 1" />
  </xsl:attribute>
</xsl:template>

<!-- /Dot -->


<!-- OriginalText -->
<xsl:template match="cmme:OriginalText">
  <orig>
    <xsl:apply-templates select="@ID" />
    <xsl:value-of select="cmme:Phrase" />
    <!-- <xsl:call-template name="EventAttributes" /> -->
  </orig>
</xsl:template>
<!-- /OriginalText -->


<!-- Proportion -->
<xsl:template match="cmme:Proportion">
  <proport>
      <xsl:call-template name="ProportionData" />
  </proport>
</xsl:template>

<xsl:template name="ProportionData">
  <xsl:apply-templates select="@ID" />
  <xsl:apply-templates select="cmme:Num" />
  <xsl:apply-templates select="cmme:Den" />
  <!-- <xsl:call-template name="EventAttributes" /> -->
</xsl:template>
<!-- /Proportion -->

<!-- ColorChange -->
<xsl:template match="cmme:ColorChange">

</xsl:template>
<!-- -->

<!-- Custos -->
<xsl:template match="cmme:Custos">
  <custos>
    <xsl:call-template name="CustosData" />
  </custos>
</xsl:template>

<xsl:template name="CustosData">
  <xsl:apply-templates select="@ID" />
  <xsl:call-template name="StaffPitchData" />
  <!-- <xsl:call-template name="EventAttributes" /> -->
</xsl:template>
<!-- /Custos -->


<!-- LineEnd / xxxx -->
<xsl:template match="cmme:LineEnd">
  <xsl:call-template name="LineEndData" />
</xsl:template>

<xsl:template name="LineEndData">
  <sb>
    <xsl:apply-templates select="@ID" />
  </sb>
  <xsl:apply-templates select="cmme:PageEnd" />
</xsl:template>

<xsl:template match="cmme:PageEnd">
  <pb />
</xsl:template>
<!-- /LineEnd -->


<!-- MiscItem -->
<xsl:template match="cmme:MiscItem">
  <xsl:call-template name="MiscItemData" />
</xsl:template>

<xsl:template name="MiscItemData">
  <xsl:apply-templates select="cmme:Barline" />
  <xsl:apply-templates select="cmme:TextAnnotation" />
  <xsl:apply-templates select="cmme:Lacuna" />
  <xsl:apply-templates select="cmme:Ellipsis" />
</xsl:template>

  <!-- Barline -->
<xsl:template match="cmme:Barline">
  <barLine>
    <xsl:apply-templates select="cmme:NumLines" />  
    <!-- <xsl:apply-templates select="cmme:RepeatSign" /> -->
    <xsl:apply-templates select="cmme:BottomStaffLine" />
    <xsl:apply-templates select="cmme:NumSpaces" />
  </barLine>
</xsl:template>

<xsl:template match="cmme:NumLines">
  <!-- <xsl:attribute name="">

  </xsl:attribute> -->
</xsl:template>

  <!-- /Barline -->

  <!-- TextAnnotation -->
<xsl:template match="cmme:TextAnnotation">
  <annot>
    <xsl:apply-templates select="../cmme:TextAnnotation/cmme:Text" />
  </annot>
</xsl:template>

<xsl:template match="cmme:TextAnnotation/cmme:Text">
  <xsl:value-of select="." />
</xsl:template>
  <!-- /TextAnnotation -->

  <!-- Lacuna -->
<xsl:template match="cmme:Lacuna">
  <space>
    <xsl:apply-templates select="../cmme:Lacuna/cmme:Length" />
  </space>
</xsl:template>

<xsl:template match="cmme:Lacuna/cmme:Length">
  <xsl:attribute name="dur.metrical">
    <xsl:value-of select="cmme:Num" />
  </xsl:attribute>
</xsl:template>
  <!-- /Lacuna -->

<!-- /MiscItem -->
<!-- /events representing original notational elements -->

<!-- events representing purely modern interpretational elements -->
<xsl:template match="cmme:ModernKeySignature">
  <xsl:call-template name="ModernKeySignatureData" />
</xsl:template>

<xsl:template name="ModernKeySignatureData">
    <xsl:apply-templates select="cmme:SigElement" />
</xsl:template>

<xsl:template match="cmme:SigElement">
  <keySig>
    <xsl:call-template name="ModernKeySignatureElement" />
  </keySig>
</xsl:template>

<xsl:template name="ModernKeySignatureElement">
  <xsl:apply-templates select="cmme:Pitch" />
  <xsl:apply-templates select="cmme:Accidental" />
</xsl:template>

<xsl:template match="cmme:Pitch">
  <xsl:attribute name="pname">
    <xsl:value-of select="lower-case(.)" />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:Accidental">
  <keyAccid>
    <xsl:apply-templates select="../cmme:SigElement/cmme:Octave" />
    <xsl:call-template name="SignatureAccidentals" />
  </keyAccid>
</xsl:template>

<xsl:template match="cmme:SigElement/cmme:Octave">
  <xsl:attribute name="oct">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>
<!-- /events representing purely modern interpretational elements -->


<xsl:template name="StaffPitchData">
  <xsl:if test="cmme:StaffLoc">
    <xsl:attribute name="loc">
      <xsl:value-of select="cmme:StaffLoc" />
    </xsl:attribute>
  </xsl:if>
  <xsl:call-template name="Locus" />
</xsl:template>

<!-- VariantReadings -->
<xsl:template match="cmme:VariantReadings">
  <app label="VariantReadings">
    <xsl:apply-templates select="cmme:Reading" />
  </app>
</xsl:template>

<xsl:template match="cmme:Reading">
    <rdg>
      <xsl:apply-templates select="cmme:VariantVersionID" />
      <xsl:apply-templates select="cmme:PreferredReading" />
      <xsl:apply-templates select="cmme:Error" />
      <xsl:apply-templates select="../cmme:Reading/cmme:Lacuna" />
      <xsl:apply-templates select="cmme:Music" />
    </rdg>
</xsl:template>

<xsl:template match="cmme:VariantVersionID">
  <identifier>
    <xsl:value-of select="." />
  </identifier>
</xsl:template>

<xsl:template match="cmme:PreferredReading">
  <!-- Do nothing -->
</xsl:template>

<xsl:template match="cmme:Reading/cmme:Lacuna">

</xsl:template>
<!-- /VariantReadings -->

<!-- EditorialData -->
<xsl:template match="cmme:EditorialData">
    <xsl:apply-templates select="cmme:NewReading" />
    <xsl:apply-templates select="cmme:OriginalReading" />
</xsl:template>

<xsl:template match="cmme:NewReading">
  <xsl:call-template name="SingleOrMultiEventData" />
</xsl:template>

<xsl:template match="cmme:OriginalReading">
  <choice label="OriginalReading">
      <orig>
        <!-- Lacuna -->
        <xsl:apply-templates select="cmme:Error" />
        <xsl:call-template name="SingleOrMultiEventData" />
      </orig>
  </choice>
</xsl:template>
<!-- /EditorialData -->

<xsl:template match="cmme:Error">
  <sic />
</xsl:template>

<xsl:template match="cmme:Music">
    <xsl:apply-templates select="cmme:MultiEvent"/>
    <xsl:call-template name="SingleEventData" />
</xsl:template>

<xsl:template match="cmme:MultiEvent">
  <xsl:call-template name="SingleEventData" />
</xsl:template>

<!-- Matches with Locus in the CMME schema 
    Contains the pitch letter and octave number
 -->
<xsl:template name="Locus">
  <xsl:apply-templates select="cmme:LetterName" />
  <xsl:apply-templates select="cmme:OctaveNum" />
</xsl:template>

<xsl:template match="cmme:LetterName">
  <xsl:attribute name="pname">
    <xsl:value-of select="lower-case(.)" />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:OctaveNum">
  <xsl:attribute name="oct">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>

<!-- TODO -->
<xsl:template match="cmme:ModernAccidental">
  <xsl:call-template name="ModernAccidentalData" />
</xsl:template>

<xsl:template match="cmme:Lig">
  <xsl:choose>
    <xsl:when test=".='Retrorsum'">
      <xsl:comment>ALERT: This note had a Ligature in CMME with the value Retrorsum.
        Retrorsum is an incompatible ligature with MEI.
        The value is preserved in the following add element.</xsl:comment>
      <add label="cmme-ligature"><xsl:value-of select="." /></add>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="lig">
        <xsl:value-of select="lower-case(.)" />
      </xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="cmme:Tie">
  <!-- tie for some reason the tie attribute isn't supported in mei mensural 
    Leaving this code incase future versions support it -->
  <!-- <xsl:attribute name="tie">
    <xsl:text>t</xsl:text>
  </xsl:attribute> -->
</xsl:template>

<xsl:template name="ModernAccidentalData">
  <xsl:choose>
    <xsl:when test="cmme:PitchOffset">
      <xsl:apply-templates select="cmme:PitchOffset" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="SignatureAccidentals" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="cmme:PitchOffset">
  <xsl:attribute name="accid">
    <xsl:choose>
      <xsl:when test=". = -3">
        <xsl:text>tf</xsl:text>
      </xsl:when>
      <xsl:when test=". = -2">
        <xsl:text>ff</xsl:text>
      </xsl:when>
      <xsl:when test=". = -1">
        <xsl:text>f</xsl:text>
      </xsl:when>
      <xsl:when test=". = 0">
        <xsl:text>n</xsl:text>
      </xsl:when>
      <xsl:when test=". = 1">
        <xsl:text>s</xsl:text>
      </xsl:when>
      <xsl:when test=". = 2">
        <xsl:text>x</xsl:text>
      </xsl:when>
      <xsl:when test=". = 3">
        <xsl:text>xs</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>

<xsl:template name="SignatureAccidentals">
  <xsl:apply-templates select="cmme:AType" />
</xsl:template>

<xsl:template match="cmme:AType">
  <xsl:attribute name="accid">
    <xsl:value-of select="lower-case(substring(., 1, 1))" />
  </xsl:attribute>
</xsl:template>

<xsl:template match="@ID">
  <xsl:attribute name="xml:id">
    <xsl:value-of select="." />
  </xsl:attribute>
</xsl:template>


<xsl:template name="EventAttributes">
  <xsl:apply-templates select="cmme:Colored" />
  <xsl:apply-templates select="cmme:Ambiguous" />
  <xsl:apply-templates select="cmme:Editorial" />
  <xsl:apply-templates select="cmme:Error" />
  <xsl:apply-templates select="cmme:EditorialCommentary" />
</xsl:template>

<xsl:template match="cmme:Colored">
  <xsl:attribute name="colored">
    <xsl:text>true</xsl:text>
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:Ambiguous">
  <unclear />
</xsl:template>

<xsl:template match="cmme:Editorial">

</xsl:template>

<xsl:template match="cmme:Error">
  <sic />
</xsl:template>

<xsl:template match="cmme:EditorialCommentary">
  <supplied label="EditorialCommentary">
    <xsl:value-of select="." />
  </supplied>
</xsl:template>



<!-- Coloration -->
<!-- NOTE: The next two templates have no effect on the output document.
  The two template deals with coloration of the musical data. However they are quite 
  ineffective and causes a browser window to freeze. Though it works in transformations 
  using the command line, I decided to remove the coloration feature until I can find a more 
  efficient way that works across platforms. -->
<!-- BaseColoration Variables -->
<xsl:variable name="BasePrimaryCol">
  <xsl:apply-templates select="//cmme:BaseColoration/cmme:PrimaryColor/cmme:Color" />
</xsl:variable>

<xsl:variable name="BasePrimaryFill">
  <xsl:apply-templates select="//cmme:BaseColoration/cmme:PrimaryColor/cmme:Fill" />
</xsl:variable>

<xsl:variable name="BaseSecondaryCol">
  <xsl:apply-templates select="//cmme:BaseColoration/cmme:SecondaryColor/cmme:Color" />
</xsl:variable>

<xsl:variable name="BaseSecondaryFill">
  <xsl:apply-templates select="//cmme:BaseColoration/cmme:SecondaryColor/cmme:Fill" />
</xsl:variable>
<!-- /BaseColoration Variables -->

<xsl:template name="PrimaryColor">
      <xsl:apply-templates select="preceding-sibling::cmme:ColorChange/cmme:PrimaryColor/cmme:Color" />
</xsl:template>

<xsl:template name="PrimaryFill">
      <xsl:apply-templates select="preceding-sibling::cmme:ColorChange[1]/cmme:PrimaryColor/cmme:Fill" />
</xsl:template>

<xsl:template name="SecondaryColor">
    <xsl:apply-templates select="//cmme:BaseColoration/cmme:SecondaryColor/cmme:Color" />
</xsl:template>

<xsl:template name="SecondaryFill">
    <xsl:apply-templates select="//cmme:BaseColoration/cmme:SecondaryColor/cmme:Fill" />
</xsl:template>

<xsl:template match="cmme:Color">
    <xsl:value-of select="lower-case(.)" />
</xsl:template>

<xsl:template match="cmme:Fill">
    <xsl:choose>
      <xsl:when test=".='Full'">
        <xsl:text>solid</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="lower-case(.)" />
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="colorAttribute">
  <xsl:param name="color" />
  <xsl:if test="string-length($color)>0">
    <xsl:attribute name="color">
      <xsl:value-of select="$color" />
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template name="fillAttribute">
  <xsl:param name="fill" />
  <xsl:if test="string-length($fill)>0">
    <xsl:attribute name="head.fill">
      <xsl:value-of select="$fill" />
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template name="NoteColorationCode">
  <!-- This template contains the implementation for note coloration but it is not used.
    The implementation is too inefficient to run in a browser.-->
  <xsl:choose>
    <xsl:when test="cmme:Colored">
      <xsl:attribute name="colored">
        <xsl:text>true</xsl:text>
      </xsl:attribute>
      <xsl:call-template name="colorAttribute">
        <xsl:with-param name="color" select="$BaseSecondaryCol" />
      </xsl:call-template>
      <xsl:call-template name="fillAttribute">
        <xsl:with-param name="fill" select="$BaseSecondaryFill" ></xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="//cmme:BaseColoration">
          <xsl:call-template name="colorAttribute">
            <xsl:with-param name="color" select="$BasePrimaryCol" />
          </xsl:call-template>
          <xsl:call-template name="fillAttribute">
            <xsl:with-param name="fill" select="$BasePrimaryFill" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="colorAttribute">
            <xsl:with-param name="color">
              <xsl:call-template name="PrimaryColor" />
            </xsl:with-param> 
          </xsl:call-template>
          <xsl:call-template name="fillAttribute">
            <xsl:with-param name="fill">
              <xsl:call-template name="PrimaryFill" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<!-- /Coloration -->

</xsl:stylesheet>