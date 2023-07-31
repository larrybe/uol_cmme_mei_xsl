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
  <!-- / -->
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
        <xsl:if test="cmme:Source">
          <!-- SOURCE -->
          <edition label="source">
            <name><xsl:value-of select="cmme:Source/cmme:Name" /></name>
            <identifier><xsl:value-of select="cmme:Source/cmme:ID" /></identifier>
          </edition>
        </xsl:if>
        <xsl:if test="cmme:Editor">
          <editor><xsl:value-of select="cmme:Editor" /></editor>
        </xsl:if>
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
<!-- cmme:GeneralData/Metadata END -->

<!-- cmme:VoiceData -->
<!-- Defines the musical staffs -->
<xsl:template match="cmme:VoiceData">
  <scoreDef>
    <xsl:call-template name="renderTitle" />
    <xsl:call-template name="StaffDefinition" />
  </scoreDef>
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
<!-- cmme:VoiceData END -->


<xsl:template match="cmme:MusicSection">
    <xsl:if test="cmme:Editorial or cmme:PrincipalSource">
      <annot>
        <xsl:if test="cmme:Editorial">
          <p label="CMME-Editorial"><xsl:value-of select="cmme:Editorial" /></p>
        </xsl:if>
        <xsl:if test="cmme:PrincipalSource">
            <!-- TODO: SourceInfo -->
            <bibl label="CMME-PrincipalSource">
              <name><xsl:value-of select="cmme:PrincipalSource/cmme:Name" /></name>
              <identifier><xsl:value-of select="cmme:PrincipalSource/cmme:ID" /></identifier>
            </bibl>
          </xsl:if>
      </annot>
    </xsl:if>
    <!-- Template for the music notation data -->
    <xsl:call-template name="MusicSectionData" />
</xsl:template>

<xsl:template name="MusicSectionData">
  <section>
    <xsl:apply-templates select="cmme:MensuralMusic" />
</section>
</xsl:template>

<xsl:template match="cmme:MensuralMusic">
  <xsl:call-template name="MensuralMusicData" />
</xsl:template>

<xsl:template name="MensuralMusicData">
  <!-- NumVoices -->
  <!-- BaseColoration -->
  <!-- TacetInstruction -->
  <!--<xsl:call-template name="SingleVoiceMensuralSectionData" /> REPLACED WITH BELOW-->
  <xsl:apply-templates select="cmme:Voice" />
</xsl:template>

<xsl:template match="cmme:Voice">
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
    <layer>
      <xsl:call-template name="SingleEventData" />
    </layer>
  </staff>
</xsl:template>

<xsl:template name="SingleEventData">
    <xsl:apply-templates select="*" />
</xsl:template>

<!-- events representing original notational elements -->

<!-- CLEF -->
<xsl:template match="cmme:Clef">
  <xsl:choose>
    <xsl:when test="matches(cmme:Appearance, 'C|F|G')">
      <xsl:call-template name="Clef" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="KeySignature" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="Clef">
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
    <xsl:value-of select="ceiling(cmme:StaffLoc div 2)"/>
  </xsl:attribute>
  <xsl:attribute name="oct">
    <xsl:value-of select="cmme:Pitch/cmme:OctaveNum" />
  </xsl:attribute>
  <!-- <xsl:attribute name="staff">
    <xsl:value-of select="../../cmme:VoiceNum" />
  </xsl:attribute> -->
  <xsl:attribute name="xml:id">
    <xsl:choose>
      <xsl:when test="cmme:ID">
        <xsl:value-of select="cmme:ID" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('clef-', generate-id())" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <!-- Signature -->
  <!-- EventAttributes -->
</xsl:template>

<xsl:template name="KeySignature">
  <keySig>
    <keyAccid>
      <xsl:call-template name="KeySignatureData" />
    </keyAccid>
  </keySig>
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
      <!-- TODO: The rest -->
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="loc">
    <xsl:value-of select="cmme:StaffLoc - 1" />
  </xsl:attribute>
  <xsl:attribute name="pname">
    <xsl:value-of select="lower-case(cmme:Pitch/cmme:LetterName)" />
  </xsl:attribute>
  <xsl:attribute name="oct">
    <xsl:value-of select="cmme:Pitch/cmme:OctaveNum" />
  </xsl:attribute>
</xsl:template>


<!-- MENSURATION -->
<xsl:template match="cmme:Mensuration">
  <mensur>
    <xsl:call-template name="MensurationData" />
  </mensur>
</xsl:template>

<xsl:template name="MensurationData">
  <xsl:apply-templates select="cmme:Sign" />
</xsl:template>

<xsl:template match="cmme:Sign">
  <xsl:attribute name="sign">
    <xsl:value-of select="cmme:MainSymbol" />
  </xsl:attribute>
  <xsl:if test="cmme:Orientation">
    <xsl:attribute name="orient">
      <xsl:value-of select="translate(cmme:Orientation, 'R', 'r')" />
    </xsl:attribute>
  </xsl:if>
  <xsl:if test="cmme:Strokes">
    <xsl:attribute name="slash">
      <xsl:value-of select="cmme:Strokes" />
    </xsl:attribute>
  </xsl:if>
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
  <xsl:attribute name="xml:id">
    <xsl:choose>
      <xsl:when test="cmme:ID">
        <xsl:value-of select="cmme:ID" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('mensuration-', generate-id())" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:template>


<!-- REST -->
<xsl:template match="cmme:Rest">
  <rest>
    <xsl:call-template name="RestData" />
  </rest>
</xsl:template>

<xsl:template name="RestData">
  <xsl:call-template name="NoteInfoData" />
  <!-- BottomStaffLine -->
  <!-- NumSpaces -->
  <!-- Corona --><!-- /SignumData -->
  <!-- Signum --><!-- /SignumData -->
  <!-- EventAttributes -->
</xsl:template>


<!-- NOTE -->
<xsl:template match="cmme:Note">
  <note>

    <xsl:attribute name="xml:id">
      <xsl:choose>
        <xsl:when test="cmme:ID">
          <xsl:value-of select="cmme:ssID" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('note-', generate-id())" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>

    <xsl:call-template name="NoteData" />
  </note>
</xsl:template>

<!-- NoteData -->
<xsl:template name="NoteData">
  <xsl:call-template name="NoteInfoData" />
  <xsl:call-template name="StaffPitchData" />
  <!-- TODO ModernAccidental -->
  <xsl:apply-templates select="cmme:ModernAccidental" />
  <!--  Flagged -->
  <xsl:apply-templates select="cmme:Lig" />
  <xsl:apply-templates select="cmme:Tie" />
  <xsl:apply-templates select="cmme:Stem" />
  <!-- HalfColoration -->
  <xsl:apply-templates select="cmme:Corona" />
  <!-- Signum --><!-- /SignumData -->
  <xsl:apply-templates select="cmme:ModernText" />
  <!-- EventAttributes -->
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

  <!-- Stem -->
<xsl:template match="cmme:Stem">
  <xsl:apply-templates select="cmme:Dir" />
  <xsl:apply-templates select="cmme:Side" />
</xsl:template>

<xsl:template match="cmme:Dir">
  <xsl:attribute name="stem.dir">
   <xsl:value-of select="lower-case(.)" />
  </xsl:attribute>
</xsl:template>

<xsl:template match="cmme:Side">
  <xsl:attribute name="stem.pos">
    <xsl:value-of select="lower-case(.)" />
  </xsl:attribute>
</xsl:template>
  <!-- /Stem -->

  <!-- Corona / fermata -->
<xsl:template match="cmme:Corona">
  <xsl:if test="cmme:Orientation">
    <xsl:attribute name="fermata">
      <xsl:choose>
        <xsl:when test="cmme:Orientation = Up">
          <xsl:value-of select="translate(cmme:Orientation, 'Up', 'above')" />
        </xsl:when>
        <xsl:when test="cmme:Orientation = Down">
          <xsl:value-of select="translate(cmme:Orientation, 'Down', 'below')" />
        </xsl:when>
      </xsl:choose>
    </xsl:attribute>
  </xsl:if>
</xsl:template>
<!-- /Corona -->


<!-- Signum -->

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
    <!-- @ID -->

    <xsl:call-template name="DotData" />
  </dot>
</xsl:template>

<xsl:template name="DotData">
  <xsl:choose>
    <!-- PITCH -->
    <xsl:when test="cmme:Pitch">
      <xsl:attribute name="ploc">
        <xsl:value-of select="lower-case(cmme:Pitch/cmme:LetterName)" />
      </xsl:attribute>
      <xsl:attribute name="oloc">
        <xsl:value-of select="cmme:Pitch/cmme:OctaveNum" />
      </xsl:attribute>
    </xsl:when>
    <!-- STAFFLOC -->
    <xsl:when test="cmme:StaffLoc">
      <xsl:attribute name="loc">
        <xsl:value-of select="cmme:StaffLoc" />
      </xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <!-- RelativeStaffLoc -->
      <!-- NoteEventID -->
    </xsl:otherwise>
  </xsl:choose>
  <!-- EventAttributes -->
</xsl:template>
<!-- /Dot -->


<!-- OriginalText -->
<xsl:template match="cmme:OriginalText">
  <orig>
    <xsl:value-of select="cmme:Phrase" />
  </orig>
</xsl:template>
<!-- /OriginalText -->


<!-- Proportion -->
<xsl:template match="cmme:Proportion">
  <proport>
      <!-- @ID -->
    
      <xsl:call-template name="ProportionData" />
  </proport>
</xsl:template>

<xsl:template name="ProportionData">
  <xsl:attribute name="num">
    <xsl:value-of select="cmme:Num" />
  </xsl:attribute>
  <xsl:attribute name="numbase">
    <xsl:value-of select="cmme:Den" />
  </xsl:attribute>
  <!-- EventAttributes -->
</xsl:template>
<!-- /Proportion -->


<!-- Custos -->
<xsl:template match="cmme:Custos">
  <custos>
    <!-- @ID -->

    <xsl:call-template name="StaffPitchData" />
    <!-- TODO EventAttributes -->
  </custos>
</xsl:template>
<!-- /Custos -->


<!-- LineEnd / xxxx -->
<xsl:template match="cmme:LineEnd">
  <!-- @ID -->

  <xsl:call-template name="LineEndData" />
</xsl:template>

<xsl:template name="LineEndData">
  <sb />
  <xsl:apply-templates select="cmme:PageEnd" />
</xsl:template>

<xsl:template match="cmme:PageEnd">
  <sb />
</xsl:template>
<!-- /LineEnd -->


<!-- MiscItem -->
<xsl:template match="cmme:MiscItem">
  
</xsl:template>
<!-- /MiscItem -->

<!-- /events representing original notational elements -->

<xsl:template name="StaffPitchData">
  <xsl:if test="cmme:StaffLoc">
    <xsl:attribute name="loc">
      <xsl:value-of select="cmme:StaffLoc" />
    </xsl:attribute>
  </xsl:if>
  <xsl:call-template name="Locus" />
</xsl:template>


<xsl:template match="cmme:VariantReadings">
  <app label="VariantReadings">
    <xsl:apply-templates select="cmme:Reading" />
  </app>
</xsl:template>

<xsl:template match="cmme:Reading">
  <rdg>
    <xsl:attribute name="source">
      <xsl:value-of select="cmme:VariantVersionID" />
    </xsl:attribute>
    <identifier><xsl:value-of select="cmme:VariantVersionID" /></identifier>
      <xsl:apply-templates select="cmme:Lacuna" />
      <xsl:apply-templates select="cmme:Music" />
  </rdg>
</xsl:template>

<xsl:template match="cmme:Lacuna">

</xsl:template>

<xsl:template match="cmme:Music">
  <xsl:choose>
    <xsl:when test="cmme:MultiEvent">
      
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="SingleEventData" />
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
  
</xsl:template>

</xsl:stylesheet>

<!-- 
  <xs:group name="EventAttributes">
    <xs:sequence>
  <xs:element name="Colored"   minOccurs="0" maxOccurs="1"/>
  <xs:element name="Ambiguous" minOccurs="0" maxOccurs="1"/>
  <xs:element name="Editorial" minOccurs="0" maxOccurs="1"/>
  <xs:element name="Error"     minOccurs="0" maxOccurs="1"/>
  <xs:element name="EditorialCommentary" type="xs:string" minOccurs="0" maxOccurs="1"/>
    </xs:sequence>
</xs:group>
 -->