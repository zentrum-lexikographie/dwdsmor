% flexion.fst
% Version 1.13
% Andreas Nolda 2022-09-21

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

$Fix#$      = <>:<Fix#>
$Adj#$      = <>:<Low#>
$Adj#Up$    = <>:<Up#>
$N#$        = <>:<Up#>
$N#Low/Up$  = <>:<Low#>
$V#$        = <>:<Low#>
$Closed#$   = <>:<Low#>
$Closed#Up$ = <>:<Up#>

$SS$ = <OLDORTH>:<SSalt> | <>:<SS>


% nouns

% Frau; Mythos; Chaos
$NSg_0$ = {<NGDA><Sg>}:{<FB>} $N#$

% Mensch-en
$NSg_en$ = {<Nom><Sg>}:{<FB>}       $N#$ | \
           {<GDA><Sg>}:{<FB>en}     $N#$ | \
           {<DA><Sg><NonSt>}:{<FB>} $N#$ % cf. Duden-Grammatik (2016: § 333)

% Nachbar-n
$NSg_n$ = {<Nom><Sg>}:{<FB>}  $N#$ | \
          {<GDA><Sg>}:{<FB>n} $N#$

% Haus-es, Geist-(e)s
$NSg_es$ = {<NDA><Sg>}:{<FB>}         $N#$ | \
           {<Gen><Sg>}:{<FB>es<^Gen>} $N#$ | \
           {<Dat><Sg><Old>}:{<FB>e}   $N#$ % cf. Duden-Grammatik (2016: § 317)

% Opa-s, Klima-s
$NSg_s$ = {<NDA><Sg>}:{<FB>}  $N#$ | \
          {<Gen><Sg>}:{<FB>s} $N#$

$NPl_0$ = {<NGA><Pl>}:{}  $N#$ | \
          {<Dat><Pl>}:{n} $N#$

$NPl_x$ = {<NGDA><Pl>}:{} $N#$

$N_0_\$$ =           $NSg_0$ | \
           {}:{<UL>} $NPl_0$

$N_0_\$e$ =            $NSg_0$ | \
            {}:{<UL>e} $NPl_0$

$N_0_e$ =            $NSg_0$ | \
          {}:{<FB>e} $NPl_0$

$N_0_en$ =             $NSg_0$ | \
           {}:{<FB>en} $NPl_x$

$N_0_n$ =            $NSg_0$ | \
          {}:{<FB>n} $NPl_x$

$N_0_s$ =            $NSg_0$ | \
          {}:{<FB>s} $NPl_x$

$N_0_x$ = $NSg_0$ | \
          $NPl_x$

$N_en_en$ =             $NSg_en$ | \
            {}:{<FB>en} $NPl_x$

$N_es_\$e$ =            $NSg_es$ | \
             {}:{<UL>e} $NPl_0$

$N_es_\$er$ =             $NSg_es$ | \
              {}:{<UL>er} $NPl_0$

$N_es_er$ =         $NSg_es$ | \
            {}:{er} $NPl_0$

$N_es_s$ =            $NSg_es$ | \
           {}:{<FB>s} $NPl_x$

$N_s_\$e$ =              $NSg_s$ | \
            {<>}:{<UL>e} $NPl_0$

$N_es_e$ =            $NSg_es$ | \
           {}:{<FB>e} $NPl_0$

$N_es_en$ =             $NSg_es$ | \
            {}:{<FB>en} $NPl_x$

$N_n_n$ =            $NSg_n$ | \
          {}:{<FB>n} $NPl_x$

$N_s_0$ = $NSg_s$ | \
          $NPl_0$

$N_s_\$$ =           $NSg_s$ | \
           {}:{<UL>} $NPl_0$

$N_s_\$x$ =           $NSg_s$ | \
            {}:{<UL>} $NPl_x$

$N_s_e$ =            $NSg_s$ | \
          {}:{<FB>e} $NPl_0$

$N_s_en$ =             $NSg_s$ | \
           {}:{<FB>en} $NPl_x$

$N_s_n$ =            $NSg_s$ | \
          {}:{<FB>n} $NPl_x$

$N_s_s$ =            $NSg_s$ | \
          {}:{<FB>s} $NPl_x$

$N_s_x$ = $NSg_s$ | \
          $NPl_x$


% feminine nouns

% Matrix/--
$NFem/Sg_0$ = {<+NN><Fem>}:{} $NSg_0$

% --/Matrizen
$NFem/Pl_x$ = {<+NN><Fem>}:{} $NPl_x$

% Mutter/Mütter
$NFem_0_\$$ = {<+NN><Fem>}:{} $N_0_\$$

% Wand/Wände
$NFem_0_\$e$ = {<+NN><Fem>}:{} $N_0_\$e$

% Drangsal/Drangsale; Retina/Retinae
$NFem_0_e$ = {<+NN><Fem>}:{} $N_0_e$

% Frau/Frauen; Arbeit/Arbeiten
$NFem_0_en$ = {<+NN><Fem>}:{} $N_0_en$

% Hilfe/Hilfen; Tafel/Tafeln; Nummer/Nummern
$NFem_0_n$ = {<+NN><Fem>}:{} $N_0_n$

% Oma/Omas
$NFem_0_s$ = {<+NN><Fem>}:{} $N_0_s$

% Ananas/Ananas
$NFem_0_x$ = {<+NN><Fem>}:{} $N_0_x$

% Hosteß/Hostessen
$NFem-s/ssen$ = $SS$ {<+NN><Fem>}:{} $N_0_en$

% Kenntnis/Kenntnisse
$NFem-s/sse$ = $SS$ {<+NN><Fem>}:{} $N_0_e$

% Nuß/Nüsse
$NFem-s/\$sse$ = $SS$ {<+NN><Fem>}:{} $N_0_\$e$

% Freundin/Freundinnen
$NFem-in$ =          $NFem/Sg_0$ | \
            {}:{nen} $NFem/Pl_x$

% Algebra/Algebren; Firma/Firmen
$NFem-a/en$ =              $NFem/Sg_0$ | \
              {}:{<^pl>en} $NFem/Pl_x$

% Basis/Basen
$NFem-is/en$ =              $NFem/Sg_0$ | \
               {}:{<^pl>en} $NFem/Pl_x$

% Neuritis/Neuritiden
$NFem-is/iden$ =                $NFem/Sg_0$ | \
                 {}:{<^pl>iden} $NFem/Pl_x$

% Frauenbeauftragte, Illustrierte
$NFem-Adj$ = {<+NN><Fem><NA><Sg><SW>}:{}   $N#$ | \
             {<+NN><Fem><NA><Pl><St>}:{}   $N#$ | \
             {<+NN><Fem><GD><Sg><St>}:{r}  $N#$ | \
             {<+NN><Fem><GD><Sg><Wk>}:{n}  $N#$ | \
             {<+NN><Fem><NGA><Pl><Wk>}:{n} $N#$ | \
             {<+NN><Fem><Dat><Pl><SW>}:{n} $N#$ | \
             {<+NN><Fem><Gen><Pl><St>}:{r} $N#$


% masculine nouns

% Fiskus/--
$NMasc/Sg_0$ = {<+NN><Masc>}:{} $NSg_0$

% Abwasch-(e)s/--; Glanz-es/--;
$NMasc/Sg_es$ = {<+NN><Masc>}:{} $NSg_es$

% Hagel-s/--; Adel-s/--
$NMasc/Sg_s$ = {<+NN><Masc>}:{} $NSg_s$

% --/Kurse
$NMasc/Pl_0$ = {<+NN><Masc>}:{} $NPl_0$

% --/Bauten
$NMasc/Pl_x$ = {<+NN><Masc>}:{} $NPl_x$

% Intercity/Intercitys
$NMasc_0_s$ = {<+NN><Masc>}:{} $N_0_s$

% Revers/Revers
$NMasc_0_x$ = {<+NN><Masc>}:{} $N_0_x$

% Tag-(e)s/Tage;
$NMasc_es_e$ = {<+NN><Masc>}:{} $N_es_e$

% Arzt-(e)s/Ärzte;
$NMasc_es_\$e$ = {<+NN><Masc>}:{} $N_es_\$e$

% Gott-(e)s/Götter
$NMasc_es_\$er$ = {<+NN><Masc>}:{} $N_es_\$er$

% Tenor-s/Tenöre
$NMasc_s_\$e$ = {<+NN><Masc>}:{<>} $N_s_\$e$

% Geist-(e)s/Geister
$NMasc_es_er$ = {<+NN><Masc>}:{<>} $N_es_er$

% Fleck-(e)s/Flecken
$NMasc_es_en$ = {<+NN><Masc>}:{} $N_es_en$

% Park-(e)s/Parks
$NMasc_es_s$ = {<+NN><Masc>}:{} $N_es_s$

% Adler-s/Adler; Engel-s/Engel
$NMasc_s_0$ = {<+NN><Masc>}:{} $N_s_0$

% Apfel-s/Äpfel; Vater-s/Väter
$NMasc_s_\$$ = {<+NN><Masc>}:{} $N_s_\$$

% Wagen-s/Wagen
$NMasc_s_x$ = {<+NN><Masc>}:{} $N_s_x$

% Garten-s/Gärten
$NMasc_s_\$x$ = {<+NN><Masc>}:{} $N_s_\$x$

% Drilling-s/Drillinge
$NMasc_s_e$ = {<+NN><Masc>}:{} $N_s_e$

% Zeh-s/Zehen
$NMasc_s_en$ = {<+NN><Masc>}:{} $N_s_en$

% Muskel-s/Muskeln; See-s/Seen
$NMasc_s_n$ = {<+NN><Masc>}:{} $N_s_n$

% Chef-s/Chefs; Bankier-s/Bankiers
$NMasc_s_s$ = {<+NN><Masc>}:{} $N_s_s$


% Fels-en/Felsen; Mensch-en/Menschen
$NMasc_en_en$ = {<+NN><Masc>}:{} $N_en_en$

% Affe-n/Affen; Bauer-n/Bauern
$NMasc_n_n$ = {<+NN><Masc>}:{} $N_n_n$

% Haß-Hasses/--
$NMasc-s/Sg$ = $SS$ {<+NN><Masc>}:{} $NSg_es$

% Nimbus-/Nimbusse
$NMasc-s0/sse$ = $SS$ {<+NN><Masc>}:{} $N_0_e$

% Bus/Busse; Erlaß/Erlasse
$NMasc-s/sse$ = $SS$ {<+NN><Masc>}:{} $N_es_e$

% Baß/Bässe
$NMasc-s/\$sse$ = $SS$ {<+NN><Masc>}:{} $N_es_\$e$

% Name-ns/Namen; Gedanke(n); Buchstabe
$NMasc-ns$ = {<+NN><Masc><Nom><Sg>}:{}       $N#$ | \
             {<+NN><Masc><Gen><Sg>}:{<FB>ns} $N#$ | \
             {<+NN><Masc><DA><Sg>}:{<FB>n}   $N#$ | \
             {<+NN><Masc>}:{n}               $NPl_x$

% Embryo/Embryonen (masculine)
$NMasc_0_nen$ =          $NMasc/Sg_0$ | \
                {}:{nen} $NMasc/Pl_x$

% Embryo-s/Embryonen (masculine)
$NMasc_s_nen$ =          $NMasc/Sg_s$ | \
                {}:{nen} $NMasc/Pl_x$

% Saldo/Salden
$NMasc-o/en$ =              $NMasc/Sg_s$ | \
               {}:{<^pl>en} $NMasc/Pl_x$

% Saldo/Saldi
$NMasc-o/i$ =             $NMasc/Sg_s$ | \
              {}:{<^pl>i} $NMasc/Pl_x$

% Atlas/Atlanten
$NMasc-as0/anten$ =                 $NMasc/Sg_0$ | \
                    {}:{<^pl>anten} $NMasc/Pl_x$

% Atlas-ses/Atlanten
$NMasc-as/anten$ =                 $NMasc-s/Sg$ | \
                   {}:{<^pl>anten} $NMasc/Pl_x$

% Kursus/Kurse
$NMasc-us/e$ =             $NMasc/Sg_0$ | \
               {}:{<^pl>e} $NMasc/Pl_0$

% Virus/Viren
$NMasc-us0/en$ =              $NMasc/Sg_0$ | \
                 {}:{<^pl>en} $NMasc/Pl_x$

% Virus-se/Viren
$NMasc-us/en$ =              $NMasc-s/Sg$ | \
                {}:{<^pl>en} $NMasc/Pl_x$

% Intimus/Intimi
$NMasc-us0/i$ =            $NMasc/Sg_0$ | \
               {}:{<^pl>i} $NMasc/Pl_x$

% Intimus-se/Intimi
$NMasc-us/i$ =             $NMasc-s/Sg$ | \
               {}:{<^pl>i} $NMasc/Pl_x$

% Beamte(r); Gefreite(r)
$NMasc-Adj$ = {<+NN><Masc><Nom><Sg><Wk>}:{}  $N#$ | \
              {<+NN><Masc><NA><Pl><St>}:{}   $N#$ | \
              {<+NN><Masc><Dat><Sg><St>}:{m} $N#$ | \
              {<+NN><Masc><GA><Sg><SW>}:{n}  $N#$ | \
              {<+NN><Masc><Dat><Sg><Wk>}:{n} $N#$ | \
              {<+NN><Masc><NGA><Pl><Wk>}:{n} $N#$ | \
              {<+NN><Masc><Dat><Pl><SW>}:{n} $N#$ | \
              {<+NN><Masc><Nom><Sg><St>}:{r} $N#$ | \
              {<+NN><Masc><Gen><Pl><St>}:{r} $N#$


% neuter nouns

% Abseits-/--
$NNeut/Sg_0$ = {<+NN><Neut>}:{} $NSg_0$

% Ausland-(e)s/--
$NNeut/Sg_es$ = {<+NN><Neut>}:{} $NSg_es$

% Abitur-s/--
$NNeut/Sg_s$ = {<+NN><Neut>}:{} $NSg_s$

% --/Fresken
$NNeut/Pl_x$ = {<+NN><Neut>}:{} $NPl_x$

% College/Colleges
$NNeut_0_s$ = {<+NN><Neut>}:{} $N_0_s$

% Relais-/Relais
$NNeut_0_x$ = {<+NN><Neut>}:{} $N_0_x$

% Spiel-(e)s/Spiele; Abgas-es/Abgase
$NNeut_es_e$ = {<+NN><Neut>}:{} $N_es_e$

% Floß-es/Flöße;
$NNeut_es_\$e$ = {<+NN><Neut>}:{} $N_es_\$e$

% Schild-(e)s/Schilder
$NNeut_es_er$ = {<+NN><Neut>}:{} $N_es_er$

% Buch-(e)s/Bücher
$NNeut_es_\$er$ = {<+NN><Neut>}:{} $N_es_\$er$

% Bett-(e)s/Betten
$NNeut_es_en$ = {<+NN><Neut>}:{} $N_es_en$

% Tablett-(e)s/Tabletts
$NNeut_es_s$ = {<+NN><Neut>}:{} $N_es_s$

% Feuer-s/Feuer; Mittel-s/Mittel
$NNeut_s_0$ = {<+NN><Neut>}:{} $N_s_0$

% Kloster-s/Klöster
$NNeut_s_\$$ = {<+NN><Neut>}:{} $N_s_\$$

% Almosen-s/Almosen
$NNeut_s_x$ = {<+NN><Neut>}:{} $N_s_x$

% Dreieck-s/Dreiecke
$NNeut_s_e$ = {<+NN><Neut>}:{} $N_s_e$

% Juwel-s/Juwelen
$NNeut_s_en$ = {<+NN><Neut>}:{} $N_s_en$

% Auge-s/Augen
$NNeut_s_n$ = {<+NN><Neut>}:{} $N_s_n$

% Sofa-s/Sofas; College-s/Colleges
$NNeut_s_s$ = {<+NN><Neut>}:{} $N_s_s$

% Herz-ens
$NNeut-Herz$ = {<+NN><Neut><NA><Sg>}:{<FB>}     $N#$ | \
               {<+NN><Neut><Gen><Sg>}:{<FB>ens} $N#$ | \
               {<+NN><Neut><Dat><Sg>}:{<FB>en}  $N#$ | \
               {<+NN><Neut><NGDA><Pl>}:{<FB>en} $N#$

% Innern
$NNeut-Inner$ = {<+NN><Neut><NA><Sg><Wk>}:{<FB>e}   $N#$ | \
                {<+NN><Neut><Dat><Sg><St>}:{<FB>em} $N#$ | \
                {<+NN><Neut><Gen><Sg><SW>}:{<FB>en} $N#$ | \
                {<+NN><Neut><Gen><Sg><SW>}:{<FB>n}  $N#$ | \
                {<+NN><Neut><Dat><Sg><Wk>}:{<FB>en} $N#$ | \
                {<+NN><Neut><Dat><Sg><Wk>}:{<FB>n}  $N#$ | \
                {<+NN><Neut><NA><Sg><St>}:{<FB>es}  $N#$

% Verständnis/--
$NNeut/Sg_sses$ = $SS$ $NNeut/Sg_es$

% Zeugnis/Zeugnisse
$NNeut-s/sse$ = $SS$ $NNeut_es_e$

% Faß/Fässer
$NNeut-s/\$sser$ = $SS$ $NNeut_es_\$er$

% Adverb/Adverbien
$NNeut_s_ien$ =          $NNeut/Sg_s$ | \
                {}:{ien} $NNeut/Pl_x$

% Embryo/Embryonen (neuter)
$NNeut_0_nen$ =          $NNeut/Sg_0$ | \
                {}:{nen} $NNeut/Pl_x$

% Embryo-s/Embryonen (neuter)
$NNeut_s_nen$ =          $NNeut/Sg_s$ | \
                {}:{nen} $NNeut/Pl_x$

% Komma/Kommata
$NNeut-a/ata$ =         $NNeut/Sg_s$ | \
                {}:{ta} $NNeut/Pl_x$

% Dogma/Dogmen
$NNeut-a/en$ =              $NNeut/Sg_s$ | \
               {}:{<^pl>en} $NNeut/Pl_x$

% Examen/Examina
$NNeut-en/ina$ =               $NNeut/Sg_s$ | \
                 {}:{<^pl>ina} $NNeut/Pl_x$

% Konto/Konten
$NNeut-o/en$ =              $NNeut/Sg_s$ | \
               {}:{<^pl>en} $NNeut/Pl_x$

% Cello/Celli
$NNeut-o/i$ =             $NNeut/Sg_s$ | \
              {}:{<^pl>i} $NNeut/Pl_x$

% Oxymoron/Oxymora
$NNeut-on/a$ =             $NNeut/Sg_s$ | \
               {}:{<^pl>a} $NNeut/Pl_x$

% Aktivum/Aktiva
$NNeut-um/a$ =             $NNeut/Sg_s$ | \
               {}:{<^pl>a} $NNeut/Pl_x$

% Museum/Museen
$NNeut-um/en$ =              $NNeut/Sg_s$ | \
                {}:{<^pl>en} $NNeut/Pl_x$

% Virus/Viren
$NNeut-us0/en$ =              $NNeut/Sg_0$ | \
                 {}:{<^pl>en} $NNeut/Pl_x$

% Junge(s) ('young animal')
$NNeut-Adj$ = {<+NN><Neut><NA><Sg><Wk>}:{}   $N#$ | \
              {<+NN><Neut><NA><Pl><St>}:{}   $N#$ | \
              {<+NN><Neut><Dat><Sg><St>}:{m} $N#$ | \
              {<+NN><Neut><Gen><Sg><SW>}:{n} $N#$ | \
              {<+NN><Neut><Dat><Sg><Wk>}:{n} $N#$ | \
              {<+NN><Neut><NGA><Pl><Wk>}:{n} $N#$ | \
              {<+NN><Neut><Dat><Pl><SW>}:{n} $N#$ | \
              {<+NN><Neut><Gen><Pl><St>}:{r} $N#$ | \
              {<+NN><Neut><NA><Sg><St>}:{s}  $N#$

% (das/etwas) Deutsche(s)
$NNeut-Adj/Sg$ = {<+NN><Neut><NA><Sg><Wk>}:{}   $N#$ | \
                 {<+NN><Neut><Dat><Sg><St>}:{m} $N#$ | \
                 {<+NN><Neut><Gen><Sg><SW>}:{n} $N#$ | \
                 {<+NN><Neut><Dat><Sg><Wk>}:{n} $N#$ | \
                 {<+NN><Neut><NA><Sg><St>}:{s}  $N#$


% pluralia tantum

% Leute
$N?/Pl_0$ = {<+NN><NoGend>}:{} $NPl_0$

% Kosten
$N?/Pl_x$ = {<+NN><NoGend>}:{} $NPl_x$


% proper names

% family names ending in -s, -z
$FamName_0$ = {<+NPROP><NoGend>}:{}    $NSg_0$ | \
              {<+NPROP><NoGend>}:{ens} $NPl_x$

% family names
$FamName_s$ = {<+NPROP><NoGend>}:{}  $NSg_s$ | \
              {<+NPROP><NoGend>}:{s} $NPl_x$

$Name-Fem_0$ = {<+NPROP><Fem>}:{} $NSg_0$

% Felicitas/Felicitas'
$Name-Fem_apos$ = {<+NPROP><Fem>}:{}            $NSg_0$ | \
                  {<+NPROP><Fem><Gen><Sg>}:{’} $N#$

$Name-Fem_s$ = {<+NPROP><Fem>}:{} $NSg_s$

$Name-Masc_0$ = {<+NPROP><Masc>}:{} $NSg_0$

% Andreas/Andreas'
$Name-Masc_apos$ = {<+NPROP><Masc>}:{}           $NSg_0$ | \
                   {<+NPROP><Masc><Gen><Sg>}:{’} $N#$

$Name-Masc_es$ = {<+NPROP><Masc>}:{} $NSg_es$

$Name-Masc_s$ = {<+NPROP><Masc>}:{} $NSg_s$

$Name-Neut_0$ = {<+NPROP><Neut>}:{} $NSg_0$

% Paris/Paris'
$Name-Neut_apos$ = {<+NPROP><Neut>}:{}            $NSg_0$ | \
                   {<+NPROP><Neut><Gen><Sg>}:{’} $N#$

$Name-Neut_es$ = {<+NPROP><Neut>}:{} $NSg_es$

$Name-Neut_s$ = {<+NPROP><Neut>}:{} $NSg_s$

$Name-Pl_0$ = {<+NPROP><NoGend>}:{} $NPl_0$

$Name-Pl_x$ = {<+NPROP><NoGend>}:{} $NPl_x$


% adjectives

$TMP$ = {<Fem><NA><Sg><SW>}:{e}      | \
        {<Masc><Nom><Sg><Wk>}:{e}    | \
        {<Neut><NA><Sg><Wk>}:{e}     | \
        {<NoGend><NA><Pl><St>}:{e}   | \
        {<MN><Dat><Sg><St>}:{em}     | \
        {<Fem><Gen><Sg><Wk>}:{en}    | \
        {<MN><Gen><Sg><SW>}:{en}     | \
        {<Masc><Acc><Sg><SW>}:{en}   | \
        {<MFN><Dat><Sg><Wk>}:{en}    | \
        {<NoGend><Dat><Pl><SW>}:{en} | \
        {<NoGend><NGA><Pl><Wk>}:{en} | \
        {<Fem><GD><Sg><St>}:{er}     | \
        {<Masc><Nom><Sg><St>}:{er}   | \
        {<NoGend><Gen><Pl><St>}:{er} | \
        {<Neut><NA><Sg><St>}:{es}

$AdjFlexSuff$ = $TMP$ $Adj#$

$AdjFlexSuff-Up$ = $TMP$ $Adj#Up$

% lila; klasse
$AdjPos0$ = {<+ADJ><Pos><Pred/Adv>}:{}    $Adj#$ | \
            {<+ADJ><Pos><Attr><Invar>}:{} $Adj#$

% innen; feil
$AdjPosPred$ = {<+ADJ><Pos><Pred/Adv>}:{} $Adj#$

% zig
$AdjPos0Attr$ = {<+ADJ><Pos><Attr><Invar>}:{} $Adj#$

% Berliner ('related to Berlin')
$AdjPos0Attr-Up$ = {<+ADJ><Pos><Attr/Subst><Invar>}:{} $Adj#Up$

% bloß, bloß-; derartig, derartig-
$AdjPos$ = {<+ADJ><Pos><Pred/Adv>}:{<FB>}   $Adj#$ | \
           {<+ADJ><Pos><Attr/Subst>}:{<FB>} $AdjFlexSuff$

% Rh-positiv, Rh-positiv-; Tbc-krank, Tbc-krank-
$AdjPos-Up$ = {<+ADJ><Pos><Pred/Adv>}:{<FB>}   $Adj#Up$ | \
              {<+ADJ><Pos><Attr/Subst>}:{<FB>} $AdjFlexSuff-Up$

% ander-; vorig-
$AdjPosAttr$ = {<+ADJ><Pos><Lemma>}:{}          $Adj#$ | \
               {<+ADJ><Pos><Attr/Subst>}:{<FB>} $AdjFlexSuff$

% Armee-eigen-
$AdjPosAttr-Up$ = {<+ADJ><Pos><Lemma>}:{}          $Adj#Up$ | \
                  {<+ADJ><Pos><Attr/Subst>}:{<FB>} $AdjFlexSuff-Up$

% besser, besser-; höher, höher-
$AdjComp$ = {<+ADJ><Comp><Pred/Adv>}:{er}   $Adj#$ | \
            {<+ADJ><Comp><Attr/Subst>}:{er} $AdjFlexSuff$

% mehr; weniger
$AdjComp0$ = {<+ADJ><Comp><Pred/Adv>}:{}          $Adj#$ | \
             {<+ADJ><Comp><Attr/Subst><Invar>}:{} $Adj#$

% besten, best-; höchsten, höchst-
$AdjSup$ = {<+ADJ><Sup><Pred/Adv>}:{sten} $Adj#$ | \
           {<+ADJ><Sup><Attr/Subst>}:{st} $AdjFlexSuff$

% allerbesten, allerbest-; allerhöchsten, allerhöchst-
$AdjSup-aller$ = {<+ADJ><Sup><Lemma>}:{st}      $Adj#$ | \
                 {<+ADJ><Sup><Pred/Adv>}:{sten} $Adj#$ | \
                 {<+ADJ><Sup><Attr/Subst>}:{st} $AdjFlexSuff$

% faul-, fauler-, faulst-
$Adj+$ =           $AdjPos$  | \
         {}:{<FB>} $AdjComp$ | \
         {}:{<FB>} $AdjSup$

% bunt, bunter-, buntest-
$Adj+e$ =            $AdjPos$  | \
          {}:{<FB>}  $AdjComp$ | \
          {}:{<FB>e} $AdjSup$

% frei-, freier, frei(e)st-
$Adj+(e)$ =            $AdjPos$  | \
            {}:{<FB>}  $AdjComp$ | \
            {}:{<FB>}  $AdjSup$  | \
            {}:{<FB>e} $AdjSup$

% krass-, krasser-, krassest-; nass-, nasser-, nassest-
$Adj~+e$ = $SS$            $AdjPos$  | \
           $SS$ {}:{<FB>}  $AdjComp$ | \
           $SS$ {}:{<FB>e} $AdjSup$

% warm-, wärmer-, wärmst-
$Adj\$$ =           $AdjPos$  | \
          {}:{<UL>} $AdjComp$ | \
          {}:{<UL>} $AdjSup$

% kalt-, kälter-, kältest-
$Adj\$e$ =            $AdjPos$  | \
           {}:{<UL>}  $AdjComp$ | \
           {}:{<UL>e} $AdjSup$

% nass-, nässer-, nässest-
$Adj~\$e$ = $SS$            $AdjPos$  | \
            $SS$ {}:{<UL>}  $AdjComp$ | \
            $SS$ {}:{<UL>e} $AdjSup$

% dunkel; finster
$Adj-el/er$ = {}:{<^Ax>} $Adj+$

% deutsch; [das] Deutsch
$Adj+Lang$ = $Adj+$ | \
             $NNeut/Sg_s$


% articles and pronouns

$ArtDefAttrSuff$ = {<Attr><Fem><NA><Sg><St>}:{ie}     $Fix#$ | \
                   {<Attr><NoGend><NA><Pl><St>}:{ie}  $Fix#$ | \
                   {<Attr><MN><Dat><Sg><St>}:{em}     $Fix#$ | \
                   {<Attr><Masc><Acc><Sg><St>}:{en}   $Fix#$ | \
                   {<Attr><NoGend><Dat><Pl><St>}:{en} $Fix#$ | \
                   {<Attr><Fem><GD><Sg><St>}:{er}     $Fix#$ | \
                   {<Attr><Masc><Nom><Sg><St>}:{er}   $Fix#$ | \
                   {<Attr><NoGend><Gen><Pl><St>}:{er} $Fix#$ | \
                   {<Attr><Neut><NA><Sg><St>}:{as}    $Fix#$ | \
                   {<Attr><MN><Gen><Sg><St>}:{es}     $Fix#$

$ArtDefSubstSuff$ = {<Subst><Fem><NA><Sg><St>}:{ie}       $Fix#$ | \
                    {<Subst><NoGend><NA><Pl><St>}:{ie}    $Fix#$ | \
                    {<Subst><MN><Dat><Sg><St>}:{em}       $Fix#$ | \
                    {<Subst><Masc><Acc><Sg><St>}:{en}     $Fix#$ | \
                    {<Subst><NoGend><Dat><Pl><St>}:{enen} $Fix#$ | \
                    {<Subst><Fem><Dat><Sg><St>}:{er}      $Fix#$ | \
                    {<Subst><Masc><Nom><Sg><St>}:{er}     $Fix#$ | \
                    {<Subst><Fem><Gen><Sg><St>}:{eren}    $Fix#$ | \
                    {<Subst><NoGend><Gen><Pl><St>}:{eren} $Fix#$ | \
                    {<Subst><Fem><Gen><Sg><St>}:{erer}    $Fix#$ | \
                    {<Subst><NoGend><Gen><Pl><St>}:{erer} $Fix#$ | \
                    {<Subst><Neut><NA><Sg><St>}:{as}      $Fix#$ | \
                    {<Subst><MN><Gen><Sg><St>}:{essen}    $Fix#$

$ArtDefSuff$ = $ArtDefAttrSuff$ | \
               $ArtDefSubstSuff$

$RelSuff$ = $ArtDefSubstSuff$

$DemDefSuff$ = $ArtDefSuff$

$DemSuff$ = {<AS><Fem><NA><Sg><St>}:{e}           $Fix#$ | \
            {<AS><NoGend><NA><Pl><St>}:{e}        $Fix#$ | \
            {<AS><MN><Dat><Sg><St>}:{em}          $Fix#$ | \
            {<AS><Masc><Acc><Sg><St>}:{en}        $Fix#$ | \
            {<Attr><MN><Gen><Sg><St><NonSt>}:{en} $Fix#$ | \ % cf. Duden-Grammatik (2016: § 356, 379)
            {<AS><NoGend><Dat><Pl><St>}:{en}      $Fix#$ | \
            {<AS><Fem><GD><Sg><St>}:{er}          $Fix#$ | \
            {<AS><Masc><Nom><Sg><St>}:{er}        $Fix#$ | \
            {<AS><NoGend><Gen><Pl><St>}:{er}      $Fix#$ | \
            {<AS><Neut><NA><Sg><St>}:{es}         $Fix#$ | \
            {<AS><MN><Gen><Sg><St>}:{es}          $Fix#$

$DemSuff-dies$ = $DemSuff$ | \
                 {<AS><Neut><NA><Sg><St>}:{} $Fix#$

$DemSuff-solch/St$ = $DemSuff$

$DemSuff-solch/Wk$ = {<AS><Fem><NA><Sg><Wk>}:{e}      $Fix#$ | \
                     {<AS><Masc><Nom><Sg><Wk>}:{e}    $Fix#$ | \
                     {<AS><Neut><NA><Sg><Wk>}:{e}     $Fix#$ | \
                     {<AS><Fem><Gen><Sg><Wk>}:{en}    $Fix#$ | \
                     {<AS><MN><Gen><Sg><Wk>}:{en}     $Fix#$ | \
                     {<AS><Masc><Acc><Sg><Wk>}:{en}   $Fix#$ | \
                     {<AS><MFN><Dat><Sg><Wk>}:{en}    $Fix#$ | \
                     {<AS><NoGend><Dat><Pl><Wk>}:{en} $Fix#$ | \
                     {<AS><NoGend><NGA><Pl><Wk>}:{en} $Fix#$

$DemSuff-solch$ = $DemSuff-solch/St$ | \
                  $DemSuff-solch/Wk$ | \ % cf. Duden-Grammatik (2016: § 432)
                  {<Attr><Invar>}:{} $Fix#$

$WSuff-welch$ = $DemSuff-solch/St$ | \
                {<Attr><Invar>}:{} $Fix#$

$RelSuff-welch$ = $WSuff-welch$ % cf. Duden-Grammatik (2016: § 403)

$IndefSuff-welch$ = {<Subst><Fem><NA><Sg><St>}:{e}      $Fix#$ | \
                    {<Subst><NoGend><NA><Pl><St>}:{e}   $Fix#$ | \
                    {<Subst><MN><Dat><Sg><St>}:{em}     $Fix#$ | \
                    {<Subst><Masc><Acc><Sg><St>}:{en}   $Fix#$ | \
                    {<Subst><NoGend><Dat><Pl><St>}:{en} $Fix#$ | \
                    {<Subst><Fem><GD><Sg><St>}:{er}     $Fix#$ | \
                    {<Subst><Masc><Nom><Sg><St>}:{er}   $Fix#$ | \
                    {<Subst><NoGend><Gen><Pl><St>}:{er} $Fix#$ | \
                    {<Subst><Neut><NA><Sg><St>}:{es}    $Fix#$ | \
                    {<Subst><MN><Gen><Sg><St>}:{es}     $Fix#$

$IndefSuff-irgendwelch$ = $DemSuff-solch/St$

$IndefSuff-all$ = $DemSuff-solch/St$                            | \
                  {<Subst><MN><Dat><Sg><Wk><NonSt>}:{en} $Fix#$ | \ % cf. Duden-Grammatik (2016: § 411)
                  {<Attr><Invar>}:{}                     $Fix#$

$IndefSuff-jed/St$ = {<AS><Fem><NA><Sg><St>}:{e}           $Fix#$ | \
                     {<AS><MN><Dat><Sg><St>}:{em}          $Fix#$ | \
                     {<AS><Masc><Acc><Sg><St>}:{en}        $Fix#$ | \
                     {<Attr><MN><Gen><Sg><St><NonSt>}:{en} $Fix#$ | \ % cf. Duden-Grammatik (2016: § 356, 422)
                     {<AS><Fem><GD><Sg><St>}:{er}          $Fix#$ | \
                     {<AS><Masc><Nom><Sg><St>}:{er}        $Fix#$ | \
                     {<AS><Neut><NA><Sg><St>}:{es}         $Fix#$ | \
                     {<AS><MN><Gen><Sg><St>}:{es}          $Fix#$

$IndefSuff-jed/Wk$ = {<AS><Fem><NA><Sg><Wk>}:{e}    $Fix#$ | \
                     {<AS><Masc><Nom><Sg><Wk>}:{e}  $Fix#$ | \
                     {<AS><Neut><NA><Sg><Wk>}:{e}   $Fix#$ | \
                     {<AS><Fem><Gen><Sg><Wk>}:{en}  $Fix#$ | \
                     {<AS><MN><Gen><Sg><Wk>}:{en}   $Fix#$ | \
                     {<AS><Masc><Acc><Sg><Wk>}:{en} $Fix#$ | \
                     {<AS><MFN><Dat><Sg><Wk>}:{en}  $Fix#$

$IndefSuff-jed$ = $IndefSuff-jed/St$ | \
                  $IndefSuff-jed/Wk$

$IndefSuff-jeglich$ = $DemSuff$ | \
                      $IndefSuff-jed/Wk$

$IndefSuff-saemtlich$ = $DemSuff-solch/St$ | \
                        $DemSuff-solch/Wk$ | \
                        {<Subst><Invar>}:{} $Fix#$

$IndefSuff-beid$ = {<AS><NoGend><NA><Pl><St>}:{e}        $Fix#$ | \
                   {<Subst><Neut><Dat><Sg><St>}:{em}     $Fix#$ | \
                   {<AS><NoGend><Dat><Pl><St>}:{en}      $Fix#$ | \
                   {<AS><NoGend><Gen><Pl><St>}:{er}      $Fix#$ | \
                   {<Subst><Neut><NGA><Sg><St>}:{es}     $Fix#$ | \
                   {<Subst><Neut><NA><Sg><Wk>}:{e}       $Fix#$ | \
                   {<Subst><Neut><GD><Sg><Wk>}:{en}      $Fix#$ | \
                   {<AS><NoGend><NGDA><Pl><Wk>}:{en}     $Fix#$

$IndefSuff-einig$ = $DemSuff$

$IndefSuff-manch$ = $WSuff-welch$

$IndefSuff-mehrer$ = {<AS><NoGend><NA><Pl><St>}:{e}   $Fix#$ | \
                     {<AS><NoGend><Dat><Pl><St>}:{en} $Fix#$ | \
                     {<AS><NoGend><Gen><Pl><St>}:{er} $Fix#$ | \
                     {<AS><Neut><NA><Sg><St>}:{es}    $Fix#$

$IndefSuff0$ = {<AS><Invar>}:{} $Fix#$

$ArtIndefAttrSuff$ = {<Attr><Masc><Nom><Sg><NoInfl>}:{} $Fix#$ | \
                     {<Attr><Neut><NA><Sg><NoInfl>}:{}  $Fix#$ | \
                     {<Attr><Fem><NA><Sg><St>}:{e}      $Fix#$ | \
                     {<Attr><MN><Dat><Sg><St>}:{em}     $Fix#$ | \
                     {<Attr><Masc><Acc><Sg><St>}:{en}   $Fix#$ | \
                     {<Attr><Fem><GD><Sg><St>}:{er}     $Fix#$ | \
                     {<Attr><MN><Gen><Sg><St>}:{es}     $Fix#$

$ArtIndefSubstSuff$ = {<Subst><Fem><NA><Sg><St>}:{e}    $Fix#$ | \
                      {<Subst><MN><Dat><Sg><St>}:{em}   $Fix#$ | \
                      {<Subst><Masc><Acc><Sg><St>}:{en} $Fix#$ | \
                      {<Subst><Fem><GD><Sg><St>}:{er}   $Fix#$ | \
                      {<Subst><Masc><Nom><Sg><St>}:{er} $Fix#$ | \
                      {<Subst><Neut><NA><Sg><St>}:{es}  $Fix#$ | \
                      {<Subst><MN><Gen><Sg><St>}:{es}   $Fix#$ | \
                      {<Subst><Neut><NA><Sg><St>}:{s}   $Fix#$

$ArtIndefSuff$ = $ArtIndefAttrSuff$ | \
                 $ArtIndefSubstSuff$

$IndefSuff-ein/St$ = $ArtIndefSubstSuff$

$IndefSuff-ein/Wk$ = {<Subst><Fem><NA><Sg><Wk>}:{e}    $Fix#$ | \
                     {<Subst><Masc><Nom><Sg><Wk>}:{e}  $Fix#$ | \
                     {<Subst><Neut><NA><Sg><Wk>}:{e}   $Fix#$ | \
                     {<Subst><Fem><Gen><Sg><Wk>}:{en}  $Fix#$ | \
                     {<Subst><MN><Gen><Sg><Wk>}:{en}   $Fix#$ | \
                     {<Subst><Masc><Acc><Sg><Wk>}:{en} $Fix#$ | \
                     {<Subst><MFN><Dat><Sg><Wk>}:{en}  $Fix#$

$IndefSuff-ein$ = $IndefSuff-ein/St$ | \
                  $IndefSuff-ein/Wk$

$ArtNegAttrSuff$ = $ArtIndefAttrSuff$                           | \
                   {<Attr><NoGend><NA><Pl><St>}:{e}      $Fix#$ | \
                   {<Attr><MN><Gen><Sg><St><NonSt>}:{en} $Fix#$ | \ % cf. Duden-Grammatik (2016: § 356, 425)
                   {<Attr><NoGend><Dat><Pl><St>}:{en}    $Fix#$ | \
                   {<Attr><NoGend><Gen><Pl><St>}:{er}    $Fix#$

$ArtNegSubstSuff$ = $ArtIndefSubstSuff$                        | \
                    {<Subst><NoGend><NA><Pl><St>}:{e}   $Fix#$ | \
                    {<Subst><NoGend><Dat><Pl><St>}:{en} $Fix#$ | \
                    {<Subst><NoGend><Gen><Pl><St>}:{er} $Fix#$

$ArtNegSuff$ =  $ArtNegAttrSuff$ | \
                $ArtNegSubstSuff$

$IndefSuff-kein$ = $ArtNegSubstSuff$

$PossSuff/St$ = $ArtNegSuff$

$PossSuff/Wk$ = {<Subst><Fem><NA><Sg><Wk>}:{e}      $Fix#$ | \
                {<Subst><Masc><Nom><Sg><Wk>}:{e}    $Fix#$ | \
                {<Subst><Neut><NA><Sg><Wk>}:{e}     $Fix#$ | \
                {<Subst><Fem><Gen><Sg><Wk>}:{en}    $Fix#$ | \
                {<Subst><MN><Gen><Sg><Wk>}:{en}     $Fix#$ | \
                {<Subst><Masc><Acc><Sg><Wk>}:{en}   $Fix#$ | \
                {<Subst><MFN><Dat><Sg><Wk>}:{en}    $Fix#$ | \
                {<Subst><NoGend><Dat><Pl><Wk>}:{en} $Fix#$ | \
                {<Subst><NoGend><NGA><Pl><Wk>}:{en} $Fix#$

$PossSuff$ = $PossSuff/St$ | \
             $PossSuff/Wk$

$IProSuff0$ = {<Invar>}:{} $Fix#$

$IProSuff$ = {<NDA><Sg>}:{}   $Fix#$ | \
             {<Acc><Sg>}:{en} $Fix#$ | \
             {<Dat><Sg>}:{em} $Fix#$ | \
             {<Gen><Sg>}:{es} $Fix#$

$IProSuff-jedermann$ = {<NDA><Sg>}:{}  $Fix#$ | \
                       {<Gen><Sg>}:{s} $Fix#$

$IProSuff-man$ = {<Nom><Sg>}:{} $Fix#$

$PProNomSgSuff$ = {<Nom><Sg>}:{} $Fix#$

$PProAccSgSuff$ = {<Acc><Sg>}:{} $Fix#$

$PProDatSgSuff$ = {<Dat><Sg>}:{} $Fix#$

$PProGenSgSuff$ = {<Gen><Sg>}:{er}    $Fix#$ | \
                  {<Gen><Sg><Old>}:{} $Fix#$ % cf. Duden-Grammatik (2016: § 363)

$PProNomPlSuff$ = {<Nom><Pl>}:{} $Fix#$

$PProAccPlSuff$ = {<Acc><Pl>}:{} $Fix#$

$PProDatPlSuff$ = {<Dat><Pl>}:{} $Fix#$

$PProGenPlSuff$ = {<Gen><Pl>}:{er}    $Fix#$ | \
                  {<Gen><Pl><Old>}:{} $Fix#$ % cf. Duden-Grammatik (2016: § 363)

$PProGenPlSuff-er$ = {<Gen><Pl>}:{er}                   $Fix#$ | \
                     {<Gen><Pl><NonSt>}:{er<^Px><FB>er} $Fix#$ % cf. Duden-Grammatik (2016: § 363)

$WProNomSgSuff$ = $PProNomSgSuff$

$WProAccSgSuff$ = $PProAccSgSuff$

$WProDatSgSuff$ = $PProDatSgSuff$

$WProGenSgSuff$ = {<Gen><Sg>}:{sen} $Fix#$ | \
                  {<Gen><Sg><Old>}:{} $Fix#$ % cf. Duden-Grammatik (2016: § 404)

$IProNomSgSuff$ = $WProNomSgSuff$

$IProAccSgSuff$ = $WProAccSgSuff$

$IProDatSgSuff$ = $WProDatSgSuff$

$IProGenSgSuff$ = {<Gen><Sg>}:{sen} $Fix#$

% der, die, das (article)
$ArtDef$ = {<+ART><Def>}:{<FB>} $ArtDefSuff$

% der, die, das (relative pronoun)
$Rel$ = {<+REL>}:{<FB>} $RelSuff$

% der, die, das (demonstrative pronoun)
$DemDef$ = {<+DEM>}:{<FB>} $DemDefSuff$

% dieser, diese, dieses/dies
$Dem-dies$ = {<+DEM>}:{<FB>} $DemSuff-dies$

% solcher, solche, solches, solch
$Dem-solch$ = {<+DEM>}:{<FB>} $DemSuff-solch$

% jener, jene, jenes
$Dem$ = {<+DEM>}:{<FB>} $DemSuff$

% welcher, welche, welches, welch (interrogative pronoun)
$W-welch$ = {<+WPRO>}:{<FB>} $WSuff-welch$

% welcher, welche, welches, welch (relative pronoun)
$Rel-welch$ = {<+REL>}:{<FB>} $RelSuff-welch$

% welcher, welche, welches (indefinite pronoun)
$Indef-welch$ = {<+INDEF>}:{<FB>} $IndefSuff-welch$

% irgendwelcher, irgendwelche, irgendwelches (indefinite pronoun)
$Indef-irgendwelch$ = {<+INDEF>}:{<FB>} $IndefSuff-irgendwelch$

% aller, alle, alles
$Indef-all$ = {<+INDEF>}:{<FB>} $IndefSuff-all$

% jeder, jede, jedes
$Indef-jed$ = {<+INDEF>}:{<FB>} $IndefSuff-jed$

% jeglicher, jegliche, jegliches
$Indef-jeglich$ = {<+INDEF>}:{<FB>} $IndefSuff-jeglich$

% sämtlicher, sämtliche, sämtliches
$Indef-saemtlich$ = {<+INDEF>}:{<FB>} $IndefSuff-saemtlich$

% beide, beides
$Indef-beid$ = {<+INDEF>}:{<FB>} $IndefSuff-beid$

% einiger, einige, einiges
$Indef-einig$ = {<+INDEF>}:{<FB>} $IndefSuff-einig$

% mancher, manche, manches, manch
$Indef-manch$ = {<+INDEF>}:{<FB>} $IndefSuff-manch$

% mehrere, mehreres
$Indef-mehrer$ = {<+INDEF>}:{<FB>} $IndefSuff-mehrer$

% genug
$Indef0$ = {<+INDEF>}:{<FB>} $IndefSuff0$

% ein, eine (article)
$ArtIndef$ = {<+ART><Indef>}:{<FB>} $ArtIndefSuff$

% 'n, 'ne (clitic article)
$ArtIndef-n$ = {<+ART><Indef>}:{<FB>} $ArtIndefAttrSuff$ {<NonSt>}:{} % cf. Duden-Grammatik (2016: § 448)

% einer, eine, eines (indefinite pronoun)
$Indef-ein$ = {<+INDEF>}:{<FB>} $IndefSuff-ein$

% irgendein, irgendeine
$Indef-irgendein$ = {<+INDEF>}:{<FB>} $ArtIndefSuff$

% kein, keine (article)
$ArtNeg$ = {<+ART><Neg>}:{<FB>} $ArtNegSuff$

% keiner, keine, keines (indefinite pronoun)
$Indef-kein$ = {<+INDEF>}:{<FB>} $IndefSuff-kein$

% mein, meine
$Poss$ = {<+POSS>}:{<FB>} $PossSuff$

% unser, unsere/unsre
$Poss-er$ = {<+POSS>}:{<^Px><FB>} $PossSuff$

% (die) meinigen/Meinigen
$Poss/Wk$ = {<+POSS>}:{<FB>} $PossSuff/Wk$

% unserige/unsrige
$Poss/Wk-er$ = {<+POSS>}:{<^Px><FB>} $PossSuff/Wk$

% etwas
$IProNeut$ = {<+INDEF><Neut>}:{<FB>} $IProSuff0$

% jemand
$IProMasc$ = {<+INDEF><Masc>}:{<FB>} $IProSuff$

% jedermann
$IPro-jedermann$ = {<+INDEF><Masc>}:{<FB>} $IProSuff-jedermann$

% man
$IPro-man$ = {<+INDEF><Masc>}:{<FB>} $IProSuff-man$

% ich
$PPro1NomSg$ = {<+PPRO><Pers><1>}:{<FB>} $PProNomSgSuff$

% mich (irreflexive)
$PPro1AccSg$ = {<+PPRO><Pers><1>}:{<FB>} $PProAccSgSuff$

% mir (irreflexive)
$PPro1DatSg$ = {<+PPRO><Pers><1>}:{<FB>} $PProDatSgSuff$

% meiner, mein
$PPro1GenSg$ = {<+PPRO><Pers><1>}:{<FB>} $PProGenSgSuff$

% du
$PPro2NomSg$ = {<+PPRO><Pers><2>}:{<FB>} $PProNomSgSuff$

% dich (irreflexive)
$PPro2AccSg$ = {<+PPRO><Pers><2>}:{<FB>} $PProAccSgSuff$

% dir (irreflexive)
$PPro2DatSg$ = {<+PPRO><Pers><2>}:{<FB>} $PProDatSgSuff$

% deiner, dein
$PPro2GenSg$ = {<+PPRO><Pers><2>}:{<FB>} $PProGenSgSuff$

% sie (singular)
$PProFemNomSg$ = {<+PPRO><Pers><3><Fem>}:{<FB>} $PProNomSgSuff$

% sie (singular)
$PProFemAccSg$ = {<+PPRO><Pers><3><Fem>}:{<FB>} $PProAccSgSuff$

% ihr
$PProFemDatSg$ = {<+PPRO><Pers><3><Fem>}:{<FB>} $PProDatSgSuff$

% ihrer, ihr
$PProFemGenSg$ = {<+PPRO><Pers><3><Fem>}:{<FB>} $PProGenSgSuff$

% er
$PProMascNomSg$ = {<+PPRO><Pers><3><Masc>}:{<FB>} $PProNomSgSuff$

% ihn
$PProMascAccSg$ = {<+PPRO><Pers><3><Masc>}:{<FB>} $PProAccSgSuff$

% ihm
$PProMascDatSg$ = {<+PPRO><Pers><3><Masc>}:{<FB>} $PProDatSgSuff$

% seiner, sein
$PProMascGenSg$ = {<+PPRO><Pers><3><Masc>}:{<FB>} $PProGenSgSuff$

% es
$PProNeutNomSg$ = {<+PPRO><Pers><3><Neut>}:{<FB>} $PProNomSgSuff$

% 's (clitic pronoun)
$PProNeutNomSg-s$ = $PProNeutNomSg$ {<NonSt>}:{}

% es
$PProNeutAccSg$ = {<+PPRO><Pers><3><Neut>}:{<FB>} $PProAccSgSuff$

% 's (clitic pronoun)
$PProNeutAccSg-s$ = $PProNeutAccSg$ {<NonSt>}:{}

% ihm
$PProNeutDatSg$ = {<+PPRO><Pers><3><Neut>}:{<FB>} $PProDatSgSuff$

% seiner
$PProNeutGenSg$ = {<+PPRO><Pers><3><Neut>}:{<FB>} $PProGenSgSuff$

% wir
$PPro1NomPl$ = {<+PPRO><Pers><1>}:{<FB>} $PProNomPlSuff$

% uns (irreflexive)
$PPro1AccPl$ = {<+PPRO><Pers><1>}:{<FB>} $PProAccPlSuff$

% uns (irreflexive)
$PPro1DatPl$ = {<+PPRO><Pers><1>}:{<FB>} $PProDatPlSuff$

% unser, unserer/unsrer
$PPro1GenPl$ = {<+PPRO><Pers><1>}:{<FB>} $PProGenPlSuff-er$

% ihr
$PPro2NomPl$ = {<+PPRO><Pers><2>}:{<FB>} $PProNomPlSuff$

% euch (irreflexive)
$PPro2AccPl$ = {<+PPRO><Pers><2>}:{<FB>} $PProAccPlSuff$

% euch (irreflexive)
$PPro2DatPl$ = {<+PPRO><Pers><2>}:{<FB>} $PProDatPlSuff$

% euer, eurer
$PPro2GenPl$ = {<+PPRO><Pers><2>}:{<FB>} $PProGenPlSuff-er$

% sie (plural)
$PProNoGendNomPl$ = {<+PPRO><Pers><3><NoGend>}:{<FB>} $PProNomPlSuff$

% sie (plural)
$PProNoGendAccPl$ = {<+PPRO><Pers><3><NoGend>}:{<FB>} $PProAccPlSuff$

% ihr
$PProNoGendDatPl$ = {<+PPRO><Pers><3><NoGend>}:{<FB>} $PProDatPlSuff$

% ihrer, ihr
$PProNoGendGenPl$ = {<+PPRO><Pers><3><NoGend>}:{<FB>} $PProGenPlSuff$

% mich (reflexive)
$PRefl1AccSg$ = {<+PPRO><Refl><1>}:{<FB>} $PProAccSgSuff$

% mir (reflexive)
$PRefl1DatSg$ = {<+PPRO><Refl><1>}:{<FB>} $PProDatSgSuff$

% dich (reflexive)
$PRefl2AccSg$ = {<+PPRO><Refl><2>}:{<FB>} $PProAccSgSuff$

% dir (reflexive)
$PRefl2DatSg$ = {<+PPRO><Refl><2>}:{<FB>} $PProDatSgSuff$

% uns (reflexive)
$PRefl1Pl$ = {<+PPRO><Refl><1>}:{<FB>} $PProAccPlSuff$ | \
             {<+PPRO><Refl><1>}:{<FB>} $PProDatPlSuff$

% euch (reflexive)
$PRefl2Pl$ = {<+PPRO><Refl><2>}:{<FB>} $PProAccPlSuff$ | \
             {<+PPRO><Refl><2>}:{<FB>} $PProDatPlSuff$

% sich
$PRefl3$ = {<+PPRO><Refl><3>}:{<FB>} $PProAccSgSuff$      | \
           {<+PPRO><Refl><3>}:{<FB>} $PProDatSgSuff$      | \
           {<+PPRO><Refl><3>}:{<FB>} $PProAccPlSuff$ | \
           {<+PPRO><Refl><3>}:{<FB>} $PProDatPlSuff$

% wer (interrogative pronoun)
$WProMascNomSg$ = {<+WPRO><Masc>}:{<FB>} $WProNomSgSuff$

% wen (interrogative pronoun)
$WProMascAccSg$ = {<+WPRO><Masc>}:{<FB>} $WProAccSgSuff$

% wem (interrogative pronoun)
$WProMascDatSg$ = {<+WPRO><Masc>}:{<FB>} $WProDatSgSuff$

% wessen, wes (interrogative pronoun)
$WProMascGenSg$ = {<+WPRO><Masc>}:{<FB>} $WProGenSgSuff$

% was (interrogative pronoun)
$WProNeutNomSg$ = {<+WPRO><Neut>}:{<FB>} $WProNomSgSuff$

% was (interrogative pronoun)
$WProNeutAccSg$ = {<+WPRO><Neut>}:{<FB>} $WProAccSgSuff$

% was (interrogative pronoun)
$WProNeutDatSg$ = {<+WPRO><Neut>}:{<FB>} $WProDatSgSuff$ {<NonSt>}:{} % cf. Duden-Grammatik (2016: § 404)

% wessen, wes (interrogative pronoun)
$WProNeutGenSg$ = {<+WPRO><Neut>}:{<FB>} $WProGenSgSuff$

% wer (indefinite pronoun)
$IProMascNomSg$ = {<+INDEF><Masc>}:{<FB>} $IProNomSgSuff$

% wen (indefinite pronoun)
$IProMascAccSg$ = {<+INDEF><Masc>}:{<FB>} $IProAccSgSuff$

% wem (indefinite pronoun)
$IProMascDatSg$ = {<+INDEF><Masc>}:{<FB>} $IProDatSgSuff$

% wessen (indefinite pronoun)
$IProMascGenSg$ = {<+INDEF><Masc>}:{<FB>} $IProGenSgSuff$

% was (indefinite pronoun)
$IProNeutNomSg$ = {<+INDEF><Neut>}:{<FB>} $IProNomSgSuff$

% was (indefinite pronoun)
$IProNeutAccSg$ = {<+INDEF><Neut>}:{<FB>} $IProAccSgSuff$

% was (indefinite pronoun)
$IProNeutDatSg$ = {<+INDEF><Neut>}:{<FB>} $IProDatSgSuff$ {<NonSt>}:{}

% wessen (indefinite pronoun)
$IProNeutGenSg$ = {<+INDEF><Neut>}:{<FB>} $IProGenSgSuff$


% numerals

$CardSuff0$ = {<AS><Invar>}:{} $Closed#$

$CardSuff-ein/St$ = $ArtIndefSuff$

$CardSuff-ein/Wk$ = {<AS><Fem><NA><Sg><Wk>}:{e}    $Closed#$ | \
                    {<AS><Masc><Nom><Sg><Wk>}:{e}  $Closed#$ | \
                    {<AS><Neut><NA><Sg><Wk>}:{e}   $Closed#$ | \
                    {<AS><Fem><Gen><Sg><Wk>}:{en}  $Closed#$ | \
                    {<AS><MN><Gen><Sg><Wk>}:{en}   $Closed#$ | \
                    {<AS><Masc><Acc><Sg><Wk>}:{en} $Closed#$ | \
                    {<AS><MFN><Dat><Sg><Wk>}:{en}  $Closed#$

$CardSuff-ein$ = $CardSuff-ein/St$ | \
                 $CardSuff-ein/Wk$

$CardSuff-kein$ = $ArtNegSuff$

$CardSuff-zwei$ = $CardSuff0$                                        | \
                  {<Subst><NoGend><NA><Pl><SW><NonSt>}:{e} $Closed#$ | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><SW>}:{en}      $Closed#$ | \ % cf. Duden-Grammatik (2016: § 511)
                  {<AS><NoGend><Gen><Pl><St>}:{er}         $Closed#$     % cf. Duden-Grammatik (2016: § 511)

$CardSuff-vier$ = $CardSuff0$                                        | \
                  {<Subst><NoGend><NA><Pl><SW><NonSt>}:{e} $Closed#$ | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><SW>}:{en}      $Closed#$     % cf. Duden-Grammatik (2016: § 511)

$CardSuff-sieben$ = $CardSuff0$ | \
                    {<Subst><NoGend><NA><Pl><SW><NonSt>}:{e} $Closed#$  % cf. Duden-Grammatik (2016: § 511)

% ein, eine (cardinal)
$Card-ein$ = {<+CARD>}:{<FB>} $CardSuff-ein$

% kein, keine (cardinal)
$Card-kein$ = {<+CARD>}:{<FB>} $CardSuff-kein$

% zwei, zweien, zweier; drei, dreien, dreier
$Card-zwei$ = {<+CARD>}:{<FB>} $CardSuff-zwei$

% vier, vieren; zwölf, zwölfen
$Card-vier$ = {<+CARD>}:{<FB>} $CardSuff-vier$

% sieben
$Card-sieben$ = {<+CARD>}:{<FB>} $CardSuff-sieben$

% null; zwo; dreizehn; zwanzig; hundert
$Card0$ = <+CARD>:<> $CardSuff0$

% erst-
$Ord$ = <+ORD>:<> $AdjFlexSuff$


% adverbs

% oft; gern; sehr
$Adv$ = {<+ADV>}:{} $Closed#$

% mehr
$AdvComp0$ = {<+ADV><Comp>}:{} $Closed#$

% öfter; lieber;
$AdvComp$ = {<+ADV><Comp>}:{er} $Closed#$

% öftesten; liebsten; meisten
$AdvSup$ = {<+ADV><Sup>}:{sten} $Closed#$


% verbs

% sei; hab/habe; werde; tu
$VAImpSg$ = {<+V><Imp><Sg>}:{<^imp>} $V#$

% seid; habt; werdet; tut
$VAImpPl$ = {<+V><Imp><Pl>}:{<^imp>} $V#$

% bin; habe; werde; tue
$VAPres1SgInd$ = {<+V><1><Sg><Pres><Ind>}:{} $V#$

% bist; hast; wirst; tust
$VAPres2SgInd$ = {<+V><2><Sg><Pres><Ind>}:{} $V#$

% ist; hat; wird; tut
$VAPres3SgInd$ = {<+V><3><Sg><Pres><Ind>}:{} $V#$

% sind; haben; werden; tun
$VAPres1/3PlInd$ = {<+V><13><Pl><Pres><Ind>}:{} $V#$

% seid; habt; werdet; tut
$VAPres2PlInd$ = {<+V><2><Pl><Pres><Ind>}:{} $V#$

% sei; habe; werde; tue
$VAPres1/3SgKonj$ = {<+V><13><Sg><Pres><Subj>}:{<FB>} $V#$

% sei-st, seie-st; habe-st; werde-st; tue-st
$VAPres2SgKonj$ = {<+V><2><Sg><Pres><Subj>}:{<FB>st} $V#$

$VAPresKonjSg$ = {<+V><13><Sg><Pres><Subj>}:{<FB>}  $V#$ | \
                 {<+V><2><Sg><Pres><Subj>}:{<FB>st} $V#$

$VAPresKonjPl$ = {<+V><13><Pl><Pres><Subj>}:{<FB>n} $V#$ | \
                 {<+V><2><Pl><Pres><Subj>}:{<FB>t}  $V#$

% ward, wardst
$VAPastIndSg$ = {<+V><13><Sg><Past><Ind>}:{<FB>}  $V#$ | \
                {<+V><2><Sg><Past><Ind>}:{<FB>st} $V#$

% wurden, wurdet
$VAPastIndPl$ = {<+V><13><Pl><Past><Ind>}:{<FB>en}  $V#$ | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>t} $V#$

$VAPastKonj2$ = {<+V><2><Sg><Past><Subj>}:{<FB>st} $V#$ | \
                {<+V><2><Pl><Past><Subj>}:{<FB>t}  $V#$

$haben$ = {<haben>}:{}

$sein$ = {<sein>}:{}

$VPPres$ = {<+V><PPres>}:{}          $V#$ | \
           {<+V><PPres><zu>}:{<^zz>} $V#$

$VPPast$ = {<+V><PPast>}:{<^pp>} $V#$

$VPPast+haben$ = $VPPast$ $haben$

$VPPast+sein$ = $VPPast$ $sein$

$VPP-en$ = {}:{<FB>en} $VPPast$

$VPP-t$ =  {}:{<INS-E>t} $VPPast$

$VInf$ = {<+V><Inf>}:{}          $V#$ | \
         {<+V><Inf><zu>}:{<^zz>} $V#$

$VInf+PPres$ =        $VInf$ | \
               {}:{d} $VPPres$

$VInfStem$ = {}:{<FB>en} $VInf+PPres$

% sein, seiend; tun, tuend
$VInfStem-n$ = {}:{<FB>n}   $VInf$ | \
               {}:{<FB>end} $VPPres$

$VInf-en$ =    $VInfStem$

$VInf-n$ =     $VInfStem-n$

% kommt, schaut, arbeit-e-t
$VImpPl$ = {<+V><Imp><Pl>}:{<INS-E>t<^imp>} $V#$

% komm, schau, arbeit-e
$VImpSg$ = {<+V><Imp><Sg>}:{<INS-E><^imp>} $V#$

% flicht
$VImpSg0$ = {<+V><Imp><Sg>}:{<^imp>} $V#$

% (ich) will, bedarf
$VPres1Irreg$ = {<+V><1><Sg><Pres><Ind>}:{<FB>} $V#$

% (ich) liebe, rate, sammle
$VPres1Reg$ = {<+V><1><Sg><Pres><Ind>}:{<FB>e} $V#$

% (du) hilfst, rätst
$VPres2Irreg$ = {<+V><2><Sg><Pres><Ind>}:{<FB>st} $V#$

% (du) liebst, biet-e-st, sammelst
$VPres2Reg$ = {<+V><2><Sg><Pres><Ind>}:{<INS-E>st} $V#$

% (er) rät, will
$VPres3Irreg$ = {<+V><3><Sg><Pres><Ind>}:{<FB>} $V#$

% (er) liebt, hilft, sammelt
$VPres3Reg$ = {<+V><3><Sg><Pres><Ind>}:{<INS-E>t} $V#$

% (wir) lieben, wollen, sammeln
$VPresPlInd$ = {<+V><13><Pl><Pres><Ind>}:{<FB>en}  $V#$ | \
% (ihr) liebt, biet-e-t, sammelt
               {<+V><2><Pl><Pres><Ind>}:{<INS-E>t} $V#$

% (ich) liebe, wolle, sammle
$VPresKonj$ = {<+V><13><Sg><Pres><Subj>}:{<FB>e}  $V#$ | \
% (du) liebest, wollest, sammelst
              {<+V><2><Sg><Pres><Subj>}:{<FB>est} $V#$ | \
% (wir) lieben, wollen, sammeln
              {<+V><13><Pl><Pres><Subj>}:{<FB>en} $V#$ | \
% (ihr) liebet, wollet, sammelt
              {<+V><2><Pl><Pres><Subj>}:{<FB>et}  $V#$

% (ich) liebte, wollte, arbeit-e-te
$VPastIndReg$ = {<+V><13><Sg><Past><Ind>}:{<INS-E>te}  $V#$ | \
% (ich) brachte
                {<+V><2><Sg><Past><Ind>}:{<INS-E>test} $V#$ | \
                {<+V><13><Pl><Past><Ind>}:{<INS-E>ten} $V#$ | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>tet}  $V#$

% (ich) wurde
$VPastIndIrreg$ = {<+V><13><Sg><Past><Ind>}:{<FB>e}  $V#$ | \
                  {<+V><2><Sg><Past><Ind>}:{<FB>est} $V#$ | \
                  {<+V><13><Pl><Past><Ind>}:{<FB>en} $V#$ | \
                  {<+V><2><Pl><Past><Ind>}:{<FB>et}  $V#$

% (ich) fuhr, ritt, fand
$VPastIndStr$ = {<+V><13><Sg><Past><Ind>}:{<FB>}     $V#$ | \
% (du) fuhrst, ritt-e-st, fand-e-st
                {<+V><2><Sg><Past><Ind>}:{<INS-E>st} $V#$ | \
                {<+V><13><Pl><Past><Ind>}:{<FB>en}   $V#$ | \
                {<+V><2><Pl><Past><Ind>}:{<INS-E>t}  $V#$

% (ich) liebte, wollte, arbeit-e-te
$VPastKonjReg$ = {<+V><13><Sg><Past><Subj>}:{<INS-E>te}  $V#$ | \
% (ich) brächte
                 {<+V><2><Sg><Past><Subj>}:{<INS-E>test} $V#$ | \
                 {<+V><13><Pl><Past><Subj>}:{<INS-E>ten} $V#$ | \
                 {<+V><2><Pl><Past><Subj>}:{<INS-E>tet}  $V#$

% (ich) führe, ritte, fände
$VPastKonjStr$ = {<+V><13><Sg><Past><Subj>}:{<FB>e}  $V#$ | \
                 {<+V><2><Sg><Past><Subj>}:{<FB>est} $V#$ | \
                 {<+V><13><Pl><Past><Subj>}:{<FB>en} $V#$ | \
                 {<+V><2><Pl><Past><Subj>}:{<FB>et}  $V#$

$VFlexPres2$ = $VPres2Irreg$ | \
               $VPres3Reg$

$VFlexPres2t$ = $VPres2Irreg$ | \
                $VPres3Irreg$

$VFlexPres1$ = $VPres1Reg$  | \
               $VPresPlInd$ | \
               $VPresKonj$  | \
               $VImpPl$

$VFlexPresReg$ = $VFlexPres1$ | \
                 $VPres2Reg$  | \
                 $VPres3Reg$  | \
                 $VImpSg$

$VFlexReg$ =  $VFlexPresReg$ | \
              $VPastIndReg$  | \
              $VPastKonjReg$

$VModFlexSg$ = $VPres1Irreg$ | \
               $VPres2Reg$   | \
               $VPres3Irreg$

$VModFlexPl$ = $VPresPlInd$ | \
               $VPresKonj$

$VVPres$ = $VFlexPresReg$ | \
           $VInfStem$

$VVPres1$ = $VFlexPres1$ | \
            $VInfStem$

$VVPres1+Imp$ = $VImpSg$ | \
                $VVPres1$

$VVPres2$ = $VFlexPres2$

$VVPres2t$ = $VFlexPres2t$

$VVPres2+Imp$ = $VImpSg$ | \
                $VVPres2$

$VVPres2+Imp0$ = $VImpSg0$ | \
                 $VVPres2t$

% bedarf-; weiss-
$VVPresSg$ = $VModFlexSg$

% bedürf-, wiss-
$VVPresPl$ = $VModFlexPl$ | \
             $VInfStem$

$VVPastIndReg$ = $VPastIndReg$

$VVPastIndStr$ = $VPastIndStr$

$VVPastKonjReg$ = $VPastKonjReg$

$VVPastKonjStr$ = $VPastKonjStr$

$VVPastStr$ = $VVPastIndStr$ | \
              $VVPastKonjStr$

$VVRegFin$ = $VFlexReg$

$VVReg$ = $VFlexReg$ | \
          $VPP-t$    | \
          $VInfStem$

$VVReg+haben$ = $VFlexReg$ | \
                $VPP-t$ $haben$ | \
                $VInfStem$

$VVReg+sein$ = $VFlexReg$ | \
               $VPP-t$ $sein$ | \
               $VInfStem$

$VVReg-el/er$ = $VVReg$

$VVReg-el/er+haben$ = $VVReg+haben$

$VVReg-el/er+sein$ = $VVReg+sein$

$VMPastKonj$ = $VPastKonjReg$

$VMPresSg$ = $VModFlexSg$

$VMPresPl$ = $VModFlexPl$ | \
             $VInfStem$

$VMPast$ = $VPastIndReg$ | \
           $VPP-t$

$VMPast+haben$ = $VPastIndReg$ | \
                 $VPP-t$ $haben$

$VMPast+sein$ = $VPastIndReg$ | \
                $VPP-t$ $sein$

$VVPP-en$ = $VPP-en$

$VVPP-en+haben$ = $VPP-en$ $haben$

$VVPP-en+sein$ = $VPP-en$ $sein$

$VVPP-t$ = $VPP-t$

$VVPP-t+haben$ = $VPP-t$ $haben$

$VVPP-t+sein$ = $VPP-t$ $sein$


% adpositions

$Postp-Akk$ = {<+POSTP><Acc>}:{} $Closed#$

$Postp-Dat$ = {<+POSTP><Dat>}:{} $Closed#$

$Postp-Gen$ = {<+POSTP><Gen>}:{} $Closed#$

$Prep-Akk$ = {<+PREP><Acc>}:{} $Closed#$

$Prep-Dat$ = {<+PREP><Dat>}:{} $Closed#$

$Prep-Gen$ = {<+PREP><Gen>}:{} $Closed#$

$Prep-GDA$ = {<+PREP><GDA>}:{} $Closed#$

$Prep-DA$ = {<+PREP><DA>}:{} $Closed#$

$Prep-GD$ = {<+PREP><GD>}:{} $Closed#$

$Prep/Art-m$ = {<+PREPART><MN><Dat><Sg>}:{} $Closed#$

% untern (Tisch)
$Prep/Art-n$ = {<+PREPART><Masc><Acc><Sg>}:{} $Closed#$

$Prep/Art-r$ = {<+PREPART><Fem><Dat><Sg>}:{} $Closed#$

$Prep/Art-s$ = {<+PREPART><Neut><Acc><Sg>}:{} $Closed#$

$Circp$ = {<+CIRCP>}:{} $Fix#$


% abbreviations

% Ew. (= Euer)
$Abk_POSS$ = {<+POSS><Attr><Invar>}:{} $Fix#$


% other words

$Intj$ = {<+INTJ>}:{} $Closed#$

$IntjUp$ = {<+INTJ>}:{} $Closed#Up$

$Konj-Inf$ = {<+CONJ><Inf>}:{} $Closed#$

$Konj-Kon$ = {<+CONJ><Coord>}:{} $Closed#$

$Konj-Sub$ = {<+CONJ><Sub>}:{} $Closed#$

$Konj-Vgl$ = {<+CONJ><Compar>}:{} $Closed#$

$PInd-Invar$ = {<+INDEF><Invar>}:{} $Closed#$

$ProAdv$ = {<+PROADV>}:{} $Closed#$

$Ptkl-Adj$ = {<+PTCL><Adj>}:{} $Closed#$

$Ptkl-Ant$ = {<+PTCL><Ant>}:{} $Closed#$

$Ptkl-Neg$ = {<+PTCL><Neg>}:{} $Closed#$

$Ptkl-Zu$ = {<+PTCL><zu>}:{} $Closed#$

$WAdv$ = {<+WADV>}:{} $Closed#$

$Trunc$ = {<+TRUNC>}:{} $Closed#$

$NTrunc$ = {<+TRUNC>}:{} $N#$

$Pref/Adv$ = {<+VPART><Adv>}:{} $Fix#$

$Pref/Adj$ = {<+VPART><Adj>}:{} $Fix#$

$Pref/ProAdv$ = {<+VPART><ProAdv>}:{} $Fix#$

$Pref/N$ = {<+VPART><NN>}:{} $Fix#$

$Pref/V$ = {<+VPART><V>}:{} $Fix#$

$Pref/Sep$ = {<+VPART>}:{} $Fix#$


% inflection transducer

$FLEXION$ = <>:<Abk_POSS>              $Abk_POSS$          | \
            <>:<Adj$>                  $Adj\$$             | \
            <>:<Adj$e>                 $Adj\$e$            | \
            <>:<Adj+>                  $Adj+$              | \
            <>:<Adj+(e)>               $Adj+(e)$           | \
            <>:<Adj+e>                 $Adj+e$             | \
            <>:<Adj+Lang>              $Adj+Lang$          | \
            <>:<Adj-el/er>             $Adj-el/er$         | \
            <>:<AdjComp>               $AdjComp$           | \
            <>:<AdjComp0>              $AdjComp0$          | \
            <>:<AdjPos0>               $AdjPos0$           | \
            <>:<AdjPos0Attr>           $AdjPos0Attr$       | \
            <>:<AdjPos0Attr-Up>        $AdjPos0Attr-Up$    | \
            <>:<AdjPos>                $AdjPos$            | \
            <>:<AdjPos-Up>             $AdjPos-Up$         | \
            <>:<AdjPosAttr>            $AdjPosAttr$        | \
            <>:<AdjPosAttr-Up>         $AdjPosAttr-Up$     | \
            <>:<AdjPosPred>            $AdjPosPred$        | \
            <>:<AdjSup>                $AdjSup$            | \
            <>:<AdjSup-aller>          $AdjSup-aller$      | \
            <>:<Adj~$e>                $Adj~\$e$           | \
            <>:<Adj~+e>                $Adj~+e$            | \
            <>:<Adv>                   $Adv$               | \
            <>:<AdvComp>               $AdvComp$           | \
            <>:<AdvComp0>              $AdvComp0$          | \
            <>:<AdvSup>                $AdvSup$            | \
            <>:<ArtDef>                $ArtDef$            | \
            <>:<ArtIndef>              $ArtIndef$          | \
            <>:<ArtIndef-n>            $ArtIndef-n$        | \
            <>:<ArtNeg>                $ArtNeg$            | \
            <>:<Card0>                 $Card0$             | \
            <>:<Card-ein>              $Card-ein$          | \
            <>:<Card-kein>             $Card-kein$         | \
            <>:<Card-sieben>           $Card-sieben$       | \
            <>:<Card-vier>             $Card-vier$         | \
            <>:<Card-zwei>             $Card-zwei$         | \
            <>:<Circp>                 $Circp$             | \
            <>:<Dem>                   $Dem$               | \
            <>:<Dem-dies>              $Dem-dies$          | \
            <>:<Dem-solch>             $Dem-solch$         | \
            <>:<DemDef>                $DemDef$            | \
            <>:<FamName_0>             $FamName_0$         | \
            <>:<FamName_s>             $FamName_s$         | \
            <>:<Indef0>                $Indef0$            | \
            <>:<Indef-all>             $Indef-all$         | \
            <>:<Indef-beid>            $Indef-beid$        | \
            <>:<Indef-ein>             $Indef-ein$         | \
            <>:<Indef-einig>           $Indef-einig$       | \
            <>:<Indef-irgendein>       $Indef-irgendein$   | \
            <>:<Indef-irgendwelch>     $Indef-irgendwelch$ | \
            <>:<Indef-jed>             $Indef-jed$         | \
            <>:<Indef-jeglich>         $Indef-jeglich$     | \
            <>:<Indef-kein>            $Indef-kein$        | \
            <>:<Indef-manch>           $Indef-manch$       | \
            <>:<Indef-mehrer>          $Indef-mehrer$      | \
            <>:<Indef-saemtlich>       $Indef-saemtlich$   | \
            <>:<Indef-welch>           $Indef-welch$       | \
            <>:<IPro-jedermann>        $IPro-jedermann$    | \
            <>:<IPro-man>              $IPro-man$          | \
            <>:<IProMasc>              $IProMasc$          | \
            <>:<IProMascAccSg>         $IProMascAccSg$     | \
            <>:<IProMascDatSg>         $IProMascDatSg$     | \
            <>:<IProMascGenSg>         $IProMascGenSg$     | \
            <>:<IProMascNomSg>         $IProMascNomSg$     | \
            <>:<IProNeut>              $IProNeut$          | \
            <>:<IProNeutAccSg>         $IProNeutAccSg$     | \
            <>:<IProNeutDatSg>         $IProNeutDatSg$     | \
            <>:<IProNeutGenSg>         $IProNeutGenSg$     | \
            <>:<IProNeutNomSg>         $IProNeutNomSg$     | \
            <>:<Intj>                  $Intj$              | \
            <>:<IntjUp>                $IntjUp$            | \
            <>:<Konj-Inf>              $Konj-Inf$          | \
            <>:<Konj-Kon>              $Konj-Kon$          | \
            <>:<Konj-Sub>              $Konj-Sub$          | \
            <>:<Konj-Vgl>              $Konj-Vgl$          | \
            <>:<N?/Pl_0>               $N?/Pl_0$           | \
            <>:<N?/Pl_x>               $N?/Pl_x$           | \
            <>:<NFem-Adj>              $NFem-Adj$          | \
            <>:<NFem-a/en>             $NFem-a/en$         | \
            <>:<NFem-in>               $NFem-in$           | \
            <>:<NFem-is/en>            $NFem-is/en$        | \
            <>:<NFem-is/iden>          $NFem-is/iden$      | \
            <>:<NFem-s/$sse>           $NFem-s/\$sse$      | \
            <>:<NFem-s/sse>            $NFem-s/sse$        | \
            <>:<NFem-s/ssen>           $NFem-s/ssen$       | \
            <>:<NFem/Pl_x>             $NFem/Pl_x$         | \
            <>:<NFem/Sg_0>             $NFem/Sg_0$         | \
            <>:<NFem_0_$>              $NFem_0_\$$         | \
            <>:<NFem_0_$e>             $NFem_0_\$e$        | \
            <>:<NFem_0_e>              $NFem_0_e$          | \
            <>:<NFem_0_en>             $NFem_0_en$         | \
            <>:<NFem_0_n>              $NFem_0_n$          | \
            <>:<NFem_0_s>              $NFem_0_s$          | \
            <>:<NFem_0_x>              $NFem_0_x$          | \
            <>:<NMasc-Adj>             $NMasc-Adj$         | \
            <>:<NMasc-as/anten>        $NMasc-as/anten$    | \
            <>:<NMasc-as0/anten>       $NMasc-as0/anten$   | \
            <>:<NMasc-ns>              $NMasc-ns$          | \
            <>:<NMasc-o/en>            $NMasc-o/en$        | \
            <>:<NMasc-o/i>             $NMasc-o/i$         | \
            <>:<NMasc-s/$sse>          $NMasc-s/\$sse$     | \
            <>:<NMasc-s/Sg>            $NMasc-s/Sg$        | \
            <>:<NMasc-s/sse>           $NMasc-s/sse$       | \
            <>:<NMasc-s0/sse>          $NMasc-s0/sse$      | \
            <>:<NMasc-us/e>            $NMasc-us/e$        | \
            <>:<NMasc-us/en>           $NMasc-us/en$       | \
            <>:<NMasc-us/i>            $NMasc-us/i$        | \
            <>:<NMasc-us0/en>          $NMasc-us0/en$      | \
            <>:<NMasc-us0/i>           $NMasc-us0/i$       | \
            <>:<NMasc/Pl_0>            $NMasc/Pl_0$        | \
            <>:<NMasc/Pl_x>            $NMasc/Pl_x$        | \
            <>:<NMasc/Sg_0>            $NMasc/Sg_0$        | \
            <>:<NMasc/Sg_es>           $NMasc/Sg_es$       | \
            <>:<NMasc/Sg_s>            $NMasc/Sg_s$        | \
            <>:<NMasc_0_nen>           $NMasc_0_nen$       | \
            <>:<NMasc_0_s>             $NMasc_0_s$         | \
            <>:<NMasc_0_x>             $NMasc_0_x$         | \
            <>:<NMasc_en_en>           $NMasc_en_en$       | \
            <>:<NMasc_es_$e>           $NMasc_es_\$e$      | \
            <>:<NMasc_es_$er>          $NMasc_es_\$er$     | \
            <>:<NMasc_es_e>            $NMasc_es_e$        | \
            <>:<NMasc_es_en>           $NMasc_es_en$       | \
            <>:<NMasc_es_er>           $NMasc_es_er$       | \
            <>:<NMasc_es_s>            $NMasc_es_s$        | \
            <>:<NMasc_n_n>             $NMasc_n_n$         | \
            <>:<NMasc_s_$>             $NMasc_s_\$$        | \
            <>:<NMasc_s_$e>            $NMasc_s_\$e$       | \
            <>:<NMasc_s_$x>            $NMasc_s_\$x$       | \
            <>:<NMasc_s_0>             $NMasc_s_0$         | \
            <>:<NMasc_s_e>             $NMasc_s_e$         | \
            <>:<NMasc_s_en>            $NMasc_s_en$        | \
            <>:<NMasc_s_n>             $NMasc_s_n$         | \
            <>:<NMasc_s_nen>           $NMasc_s_nen$       | \
            <>:<NMasc_s_s>             $NMasc_s_s$         | \
            <>:<NMasc_s_x>             $NMasc_s_x$         | \
            <>:<NNeut-Adj/Sg>          $NNeut-Adj/Sg$      | \
            <>:<NNeut-Adj>             $NNeut-Adj$         | \
            <>:<NNeut-Herz>            $NNeut-Herz$        | \
            <>:<NNeut-Inner>           $NNeut-Inner$       | \
            <>:<NNeut-a/ata>           $NNeut-a/ata$       | \
            <>:<NNeut-a/en>            $NNeut-a/en$        | \
            <>:<NNeut-en/ina>          $NNeut-en/ina$      | \
            <>:<NNeut-o/en>            $NNeut-o/en$        | \
            <>:<NNeut-o/i>             $NNeut-o/i$         | \
            <>:<NNeut-on/a>            $NNeut-on/a$        | \
            <>:<NNeut-s/$sser>         $NNeut-s/\$sser$    | \
            <>:<NNeut-s/sse>           $NNeut-s/sse$       | \
            <>:<NNeut-um/a>            $NNeut-um/a$        | \
            <>:<NNeut-um/en>           $NNeut-um/en$       | \
            <>:<NNeut-us0/en>          $NNeut-us0/en$      | \
            <>:<NNeut/Pl_x>            $NNeut/Pl_x$        | \
            <>:<NNeut/Sg_0>            $NNeut/Sg_0$        | \
            <>:<NNeut/Sg_es>           $NNeut/Sg_es$       | \
            <>:<NNeut/Sg_s>            $NNeut/Sg_s$        | \
            <>:<NNeut/Sg_sses>         $NNeut/Sg_sses$     | \
            <>:<NNeut_0_nen>           $NNeut_0_nen$       | \
            <>:<NNeut_0_s>             $NNeut_0_s$         | \
            <>:<NNeut_0_x>             $NNeut_0_x$         | \
            <>:<NNeut_es_$e>           $NNeut_es_\$e$      | \
            <>:<NNeut_es_$er>          $NNeut_es_\$er$     | \
            <>:<NNeut_es_e>            $NNeut_es_e$        | \
            <>:<NNeut_es_en>           $NNeut_es_en$       | \
            <>:<NNeut_es_er>           $NNeut_es_er$       | \
            <>:<NNeut_es_s>            $NNeut_es_s$        | \
            <>:<NNeut_s_$>             $NNeut_s_\$$        | \
            <>:<NNeut_s_0>             $NNeut_s_0$         | \
            <>:<NNeut_s_e>             $NNeut_s_e$         | \
            <>:<NNeut_s_en>            $NNeut_s_en$        | \
            <>:<NNeut_s_ien>           $NNeut_s_ien$       | \
            <>:<NNeut_s_n>             $NNeut_s_n$         | \
            <>:<NNeut_s_nen>           $NNeut_s_nen$       | \
            <>:<NNeut_s_s>             $NNeut_s_s$         | \
            <>:<NNeut_s_x>             $NNeut_s_x$         | \
            <>:<Name-Fem_0>            $Name-Fem_0$        | \
            <>:<Name-Fem_apos>         $Name-Fem_apos$     | \
            <>:<Name-Fem_s>            $Name-Fem_s$        | \
            <>:<Name-Masc_0>           $Name-Masc_0$       | \
            <>:<Name-Masc_apos>        $Name-Masc_apos$    | \
            <>:<Name-Masc_es>          $Name-Masc_es$      | \
            <>:<Name-Masc_s>           $Name-Masc_s$       | \
            <>:<Name-Neut_0>           $Name-Neut_0$       | \
            <>:<Name-Neut_apos>        $Name-Neut_apos$    | \
            <>:<Name-Neut_es>          $Name-Neut_es$      | \
            <>:<Name-Neut_s>           $Name-Neut_s$       | \
            <>:<Name-Pl_0>             $Name-Pl_0$         | \
            <>:<Name-Pl_x>             $Name-Pl_x$         | \
            <>:<NTrunc>                $NTrunc$            | \
            <>:<Ord>                   $Ord$               | \
            <>:<PInd-Invar>            $PInd-Invar$        | \
            <>:<Poss>                  $Poss$              | \
            <>:<Poss-er>               $Poss-er$           | \
            <>:<Poss/Wk>               $Poss/Wk$           | \
            <>:<Poss/Wk-er>            $Poss/Wk-er$        | \
            <>:<Postp-Akk>             $Postp-Akk$         | \
            <>:<Postp-Dat>             $Postp-Dat$         | \
            <>:<Postp-Gen>             $Postp-Gen$         | \
            <>:<PPro1AccPl>            $PPro1AccPl$        | \
            <>:<PPro1AccSg>            $PPro1AccSg$        | \
            <>:<PPro1DatPl>            $PPro1DatPl$        | \
            <>:<PPro1DatSg>            $PPro1DatSg$        | \
            <>:<PPro1GenPl>            $PPro1GenPl$        | \
            <>:<PPro1GenSg>            $PPro1GenSg$        | \
            <>:<PPro1NomPl>            $PPro1NomPl$        | \
            <>:<PPro1NomSg>            $PPro1NomSg$        | \
            <>:<PPro2AccPl>            $PPro2AccPl$        | \
            <>:<PPro2AccSg>            $PPro2AccSg$        | \
            <>:<PPro2DatPl>            $PPro2DatPl$        | \
            <>:<PPro2DatSg>            $PPro2DatSg$        | \
            <>:<PPro2GenPl>            $PPro2GenPl$        | \
            <>:<PPro2GenSg>            $PPro2GenSg$        | \
            <>:<PPro2NomPl>            $PPro2NomPl$        | \
            <>:<PPro2NomSg>            $PPro2NomSg$        | \
            <>:<PProFemAccSg>          $PProFemAccSg$      | \
            <>:<PProFemDatSg>          $PProFemDatSg$      | \
            <>:<PProFemGenSg>          $PProFemGenSg$      | \
            <>:<PProFemNomSg>          $PProFemNomSg$      | \
            <>:<PProMascAccSg>         $PProMascAccSg$     | \
            <>:<PProMascDatSg>         $PProMascDatSg$     | \
            <>:<PProMascGenSg>         $PProMascGenSg$     | \
            <>:<PProMascNomSg>         $PProMascNomSg$     | \
            <>:<PProNeutAccSg>         $PProNeutAccSg$     | \
            <>:<PProNeutAccSg-s>       $PProNeutAccSg-s$   | \
            <>:<PProNeutDatSg>         $PProNeutDatSg$     | \
            <>:<PProNeutGenSg>         $PProNeutGenSg$     | \
            <>:<PProNeutNomSg>         $PProNeutNomSg$     | \
            <>:<PProNeutNomSg-s>       $PProNeutNomSg-s$   | \
            <>:<PProNoGendAccPl>       $PProNoGendAccPl$   | \
            <>:<PProNoGendDatPl>       $PProNoGendDatPl$   | \
            <>:<PProNoGendGenPl>       $PProNoGendGenPl$   | \
            <>:<PProNoGendNomPl>       $PProNoGendNomPl$   | \
            <>:<PRefl1AccSg>           $PRefl1AccSg$       | \
            <>:<PRefl1DatSg>           $PRefl1DatSg$       | \
            <>:<PRefl2AccSg>           $PRefl2AccSg$       | \
            <>:<PRefl2DatSg>           $PRefl2DatSg$       | \
            <>:<PRefl1Pl>              $PRefl1Pl$          | \
            <>:<PRefl2Pl>              $PRefl2Pl$          | \
            <>:<PRefl3>                $PRefl3$            | \
            <>:<Prep-Akk>              $Prep-Akk$          | \
            <>:<Prep-Dat>              $Prep-Dat$          | \
            <>:<Prep-Gen>              $Prep-Gen$          | \
            <>:<Prep-GDA>              $Prep-GDA$          | \
            <>:<Prep-GD>               $Prep-GD$           | \
            <>:<Prep-DA>               $Prep-DA$           | \
            <>:<Pref/Adj>              $Pref/Adj$          | \
            <>:<Pref/Adv>              $Pref/Adv$          | \
            <>:<Pref/N>                $Pref/N$            | \
            <>:<Pref/ProAdv>           $Pref/ProAdv$       | \
            <>:<Pref/Sep>              $Pref/Sep$          | \
            <>:<Pref/V>                $Pref/V$            | \
            <>:<Prep/Art-m>            $Prep/Art-m$        | \
            <>:<Prep/Art-n>            $Prep/Art-n$        | \
            <>:<Prep/Art-r>            $Prep/Art-r$        | \
            <>:<Prep/Art-s>            $Prep/Art-s$        | \
            <>:<ProAdv>                $ProAdv$            | \
            <>:<Ptkl-Adj>              $Ptkl-Adj$          | \
            <>:<Ptkl-Ant>              $Ptkl-Ant$          | \
            <>:<Ptkl-Neg>              $Ptkl-Neg$          | \
            <>:<Ptkl-Zu>               $Ptkl-Zu$           | \
            <>:<Rel>                   $Rel$               | \
            <>:<Rel-welch>             $Rel-welch$         | \
            <>:<Trunc>                 $Trunc$             | \
            <>:<VAImpPl>               $VAImpPl$           | \
            <>:<VAImpSg>               $VAImpSg$           | \
            <>:<VAPastIndPl>           $VAPastIndPl$       | \
            <>:<VAPastIndSg>           $VAPastIndSg$       | \
            <>:<VAPastKonj2>           $VAPastKonj2$       | \
            <>:<VAPres1/3PlInd>        $VAPres1/3PlInd$    | \
            <>:<VAPres1/3SgKonj>       $VAPres1/3SgKonj$   | \
            <>:<VAPres1SgInd>          $VAPres1SgInd$      | \
            <>:<VAPres2PlInd>          $VAPres2PlInd$      | \
            <>:<VAPres2SgInd>          $VAPres2SgInd$      | \
            <>:<VAPres2SgKonj>         $VAPres2SgKonj$     | \
            <>:<VAPres3SgInd>          $VAPres3SgInd$      | \
            <>:<VAPresKonjPl>          $VAPresKonjPl$      | \
            <>:<VAPresKonjSg>          $VAPresKonjSg$      | \
            <>:<VInf>                  $VInf$              | \
            <>:<VInf+PPres>            $VInf+PPres$        | \
            <>:<VInf-en>               $VInf-en$           | \
            <>:<VInf-n>                $VInf-n$            | \
            <>:<VMPast>                $VMPast$            | \
            <>:<VMPast><>:<haben>      $VMPast+haben$      | \
            <>:<VMPast><>:<sein>       $VMPast+sein$       | \
            <>:<VMPastKonj>            $VMPastKonj$        | \
            <>:<VMPresPl>              $VMPresPl$          | \
            <>:<VMPresSg>              $VMPresSg$          | \
            <>:<VPPast>                $VPPast$            | \
            <>:<VPPast><>:<haben>      $VPPast+haben$      | \
            <>:<VPPast><>:<sein>       $VPPast+sein$       | \
            <>:<VPPres>                $VPPres$            | \
            <>:<VPastIndIrreg>         $VPastIndIrreg$     | \
            <>:<VPastIndReg>           $VPastIndReg$       | \
            <>:<VPastIndStr>           $VPastIndStr$       | \
            <>:<VPastKonjStr>          $VPastKonjStr$      | \
            <>:<VPresKonj>             $VPresKonj$         | \
            <>:<VPresPlInd>            $VPresPlInd$        | \
            <>:<VVPP-en>               $VVPP-en$           | \
            <>:<VVPP-en><>:<haben>     $VVPP-en+haben$     | \
            <>:<VVPP-en><>:<sein>      $VVPP-en+sein$      | \
            <>:<VVPP-t>                $VVPP-t$            | \
            <>:<VVPP-t><>:<haben>      $VVPP-t+haben$      | \
            <>:<VVPP-t><>:<sein>       $VVPP-t+sein$       | \
            <>:<VVPastIndReg>          $VVPastIndReg$      | \
            <>:<VVPastIndStr>          $VVPastIndStr$      | \
            <>:<VVPastKonjReg>         $VVPastKonjReg$     | \
            <>:<VVPastKonjStr>         $VVPastKonjStr$     | \
            <>:<VVPastStr>             $VVPastStr$         | \
            <>:<VVPres>                $VVPres$            | \
            <>:<VVPres1>               $VVPres1$           | \
            <>:<VVPres1+Imp>           $VVPres1+Imp$       | \
            <>:<VVPres2>               $VVPres2$           | \
            <>:<VVPres2+Imp>           $VVPres2+Imp$       | \
            <>:<VVPres2+Imp0>          $VVPres2+Imp0$      | \
            <>:<VVPres2t>              $VVPres2t$          | \
            <>:<VVPresPl>              $VVPresPl$          | \
            <>:<VVPresSg>              $VVPresSg$          | \
            <>:<VVReg>                 $VVReg$             | \
            <>:<VVReg><>:<haben>       $VVReg+haben$       | \
            <>:<VVReg><>:<sein>        $VVReg+sein$        | \
            <>:<VVRegFin>              $VVRegFin$          | \
            <>:<VVReg-el/er>           $VVReg-el/er$       | \
            <>:<VVReg-el/er><>:<haben> $VVReg-el/er+haben$ | \
            <>:<VVReg-el/er><>:<sein>  $VVReg-el/er+sein$  | \
            <>:<WAdv>                  $WAdv$              | \
            <>:<W-welch>               $W-welch$           | \
            <>:<WProMascAccSg>         $WProMascAccSg$     | \
            <>:<WProMascDatSg>         $WProMascDatSg$     | \
            <>:<WProMascGenSg>         $WProMascGenSg$     | \
            <>:<WProMascNomSg>         $WProMascNomSg$     | \
            <>:<WProNeutAccSg>         $WProNeutAccSg$     | \
            <>:<WProNeutDatSg>         $WProNeutDatSg$     | \
            <>:<WProNeutGenSg>         $WProNeutGenSg$     | \
            <>:<WProNeutNomSg>         $WProNeutNomSg$


% inflection filter

ALPHABET = [#char# #ss-trigger# #surface-trigger# #morpheme_boundary_marker#] <FB><VPART> \
           <^Ax><^Px><Ge-Nom><UL><ge><zu><CB> \
           <INS-E><^imp><^zz><ge><^pp><^pl><^Gen><^Del><Fix#><Low#><Up#> \
           [#entry-type#]

$=INFL$ = [#inflection#]:<>

$=AUX$ = [#auxiliary#]:<>

$FLEXFILTER$ = (.* $=INFL$ $=AUX$ $=INFL$ $=AUX$ .*) | \
               (.* $=INFL$ $=INFL$ .*)
