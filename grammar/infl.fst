% infl.fst
% Version 7.2
% Andreas Nolda 2024-08-29

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

$SS$ = <>:<dbl(s)>


% nouns

% Frau; Mythos; Chaos
$NSgSuff_0$ = {<Nom><Sg>}:{} | \
              {<Acc><Sg>}:{} | \
              {<Dat><Sg>}:{} | \
              {<Gen><Sg>}:{}

% Mensch, Menschen
$NSgSuff_en$ = {<Nom><Sg>}:{}        | \
               {<Acc><Sg>}:{<SB>en}  | \
               {<Acc><Sg><NonSt>}:{} | \
               {<Dat><Sg>}:{<SB>en}  | \
               {<Dat><Sg><NonSt>}:{} | \ % cf. Duden-Grammatik (2016: § 333)
               {<Gen><Sg>}:{<SB>en}

% Nachbar, Nachbarn
$NSgSuff_n$ = {<Nom><Sg>}:{}      | \
              {<Acc><Sg>}:{<SB>n} | \
              {<Dat><Sg>}:{<SB>n} | \
              {<Gen><Sg>}:{<SB>n}

% Haus, Hauses; Geist, Geist(e)s
$NSgSuff_es$ = {<Nom><Sg>}:{}           | \
               {<Acc><Sg>}:{}           | \
               {<Dat><Sg>}:{}           | \
               {<Dat><Sg><Old>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 317)
               {<Gen><Sg>}:{<SB>es<del(e)|Gen>}

% Opa, Opas; Klima, Klimas
$NSgSuff_s$ = {<Nom><Sg>}:{} | \
              {<Acc><Sg>}:{} | \
              {<Dat><Sg>}:{} | \
              {<Gen><Sg>}:{<SB>s}

% Name, Namens; Buchstabe, Buchstabens
$NSgSuff_ns$ = {<Nom><Sg>}:{}      | \
               {<Acc><Sg>}:{<SB>n} | \
               {<Dat><Sg>}:{<SB>n} | \
               {<Gen><Sg>}:{<SB>ns}

% Herz, Herzens
$NSgSuff_ens$ = {<Nom><Sg>}:{}       | \
                {<Acc><Sg>}:{}       | \
                {<Dat><Sg>}:{<SB>en} | \
                {<Gen><Sg>}:{<SB>ens}

$NPlSuff_x$ = {<Nom><Pl>}:{} | \
              {<Acc><Pl>}:{} | \
              {<Dat><Pl>}:{} | \
              {<Gen><Pl>}:{}

$NPlSuff_0$ = {<Nom><Pl>}:{}      | \
              {<Acc><Pl>}:{}      | \
              {<Dat><Pl>}:{<SB>n} | \
              {<Gen><Pl>}:{}


% masculine nouns

% Fiskus, Fiskus
$NMasc/Sg_0$ = {<+NN><Masc>}:{} $NSgSuff_0$

% Abwasch, Abwasch(e)s; Glanz, Glanzes
$NMasc/Sg_es$ = {<+NN><Masc>}:{} $NSgSuff_es$

% Hagel, Hagels; Adel, Adels
$NMasc/Sg_s$ = {<+NN><Masc>}:{} $NSgSuff_s$

% Unglaube, Unglaubens
$NMasc/Sg_ns$ = {<+NN><Masc>}:{} $NSgSuff_ns$

% Bauten (suppletive plural)
$NMasc/Pl_x$ = {<+NN><Masc>}:{} $NPlSuff_x$

% Revers, Revers, Revers
$NMasc_0_x$ = {<+NN><Masc>}:{} $NSgSuff_0$ | \
              {<+NN><Masc>}:{} $NPlSuff_x$

% Dezember, Dezember, Dezember
$NMasc_0_0$ = {<+NN><Masc>}:{} $NSgSuff_0$ | \
              {<+NN><Masc>}:{} $NPlSuff_0$

% Kodex, Kodex, Kodexe
$NMasc_0_e$ = {<+NN><Masc>}:{}      $NSgSuff_0$ | \
              {<+NN><Masc>}:{<SB>e} $NPlSuff_0$

% Nimbus, Nimbus, Nimbusse
$NMasc_0_e~ss$ = $SS$ $NMasc_0_e$

% Bypass, Bypass, Bypässe
$NMasc_0_\$e$ = {<+NN><Masc>}:{}           $NSgSuff_0$ | \
                {<+NN><Masc>}:{<uml><SB>e} $NPlSuff_0$

% Obelisk, Obelisk, Obelisken
$NMasc_0_en$ = {<+NN><Masc>}:{}       $NSgSuff_0$ | \
               {<+NN><Masc>}:{<SB>en} $NPlSuff_x$

% Kanon, Kanon, Kanones; Sandwich, Sandwich, Sandwiches (masculine)
$NMasc_0_es$ = {<+NN><Masc>}:{}       $NSgSuff_0$ | \
               {<+NN><Masc>}:{<SB>es} $NPlSuff_x$

% Embryo, Embryo, Embryonen (masculine)
$NMasc_0_nen$ = {<+NN><Masc>}:{}        $NSgSuff_0$ | \
                {<+NN><Masc>}:{n<SB>en} $NPlSuff_x$

% Intercity, Intercity, Intercitys
$NMasc_0_s$ = {<+NN><Masc>}:{}      $NSgSuff_0$ | \
              {<+NN><Masc>}:{<SB>s} $NPlSuff_x$

% Atlas, Atlas, Atlanten
$NMasc_0_as/anten$ = {<+NN><Masc>}:{}                      $NSgSuff_0$ | \
                     {<+NN><Masc>}:{<del(VC)|Pl>ant<SB>en} $NPlSuff_x$

% Carabiniere, Carabiniere, Carabinieri
$NMasc_0_e/i$ = {<+NN><Masc>}:{}                  $NSgSuff_0$ | \
                {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NPlSuff_x$

% Index, Index, Indizes
$NMasc_0_ex/izes$ = {<+NN><Masc>}:{}                     $NSgSuff_0$ | \
                    {<+NN><Masc>}:{<del(VC)|Pl>iz<SB>es} $NPlSuff_x$

% Saldo, Saldo, Salden
$NMasc_0_o/en$ = {<+NN><Masc>}:{}                   $NSgSuff_0$ | \
                 {<+NN><Masc>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Espresso, Espresso, Espressi
$NMasc_0_o/i$ = {<+NN><Masc>}:{}                  $NSgSuff_0$ | \
                {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NPlSuff_x$

% Heros, Heros, Heroen
$NMasc_0_os/oen$ = {<+NN><Masc>}:{}                    $NSgSuff_0$ | \
                   {<+NN><Masc>}:{<del(VC)|Pl>o<SB>en} $NPlSuff_x$

% Kustos, Kustos, Kustoden
$NMasc_0_os/oden$ = {<+NN><Masc>}:{}                     $NSgSuff_0$ | \
                    {<+NN><Masc>}:{<del(VC)|Pl>od<SB>en} $NPlSuff_x$

% Topos, Topos, Topoi
$NMasc_0_os/oi$ = {<+NN><Masc>}:{}                   $NSgSuff_0$ | \
                  {<+NN><Masc>}:{<del(VC)|Pl>o<SB>i} $NPlSuff_x$

% Kursus, Kursus, Kurse
$NMasc_0_us/e$ = {<+NN><Masc>}:{}                  $NSgSuff_0$ | \
                 {<+NN><Masc>}:{<del(VC)|Pl><SB>e} $NPlSuff_0$

% Virus, Virus, Viren; Mythos, Mythos, Mythen
$NMasc_0_us/en$ = {<+NN><Masc>}:{}                   $NSgSuff_0$ | \
                  {<+NN><Masc>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Kaktus, Kaktus, Kakteen
$NMasc_0_us/een$ = {<+NN><Masc>}:{}                    $NSgSuff_0$ | \
                   {<+NN><Masc>}:{<del(VC)|Pl>e<SB>en} $NPlSuff_x$

% Intimus, Intimus, Intimi
$NMasc_0_us/i$ = {<+NN><Masc>}:{}                  $NSgSuff_0$ | \
                 {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NPlSuff_x$

% Dinosaurus, Dinosaurus, Dinosaurier
$NMasc_0_us/ier$ = {<+NN><Masc>}:{}                    $NSgSuff_0$ | \
                   {<+NN><Masc>}:{<del(VC)|Pl>i<SB>er} $NPlSuff_0$

% Larynx, Larynx, Laryngen
$NMasc_0_ynx/yngen$ = {<+NN><Masc>}:{}                      $NSgSuff_0$ | \
                      {<+NN><Masc>}:{<del(VC)|Pl>yng<SB>en} $NPlSuff_x$

% Tag, Tag(e)s, Tage; Kodex, Kodexes, Kodexe
$NMasc_es_e$ = {<+NN><Masc>}:{}      $NSgSuff_es$ | \
               {<+NN><Masc>}:{<SB>e} $NPlSuff_0$

% Bus, Busses, Busse
$NMasc_es_e~ss$ = $SS$ $NMasc_es_e$

% Arzt, Arzt(e)s, Ärzte
$NMasc_es_\$e$ = {<+NN><Masc>}:{}           $NSgSuff_es$ | \
                 {<+NN><Masc>}:{<uml><SB>e} $NPlSuff_0$

% Geist, Geist(e)s, Geister
$NMasc_es_er$ = {<+NN><Masc>}:{}       $NSgSuff_es$ | \
                {<+NN><Masc>}:{<SB>er} $NPlSuff_0$

% Gott, Gott(e)s, Götter
$NMasc_es_\$er$ = {<+NN><Masc>}:{}            $NSgSuff_es$ | \
                  {<+NN><Masc>}:{<uml><SB>er} $NPlSuff_0$

% Fleck, Fleck(e)s, Flecken
$NMasc_es_en$ = {<+NN><Masc>}:{}       $NSgSuff_es$ | \
                {<+NN><Masc>}:{<SB>en} $NPlSuff_x$

% Bugfix, Bugfix(e)s, Bugfixes
$NMasc_es_es$ = {<+NN><Masc>}:{}       $NSgSuff_es$ | \
                {<+NN><Masc>}:{<SB>es} $NPlSuff_x$

% Park, Park(e)s, Parks
$NMasc_es_s$ = {<+NN><Masc>}:{}      $NSgSuff_es$ | \
               {<+NN><Masc>}:{<SB>s} $NPlSuff_x$

% Atlas, Atlasses, Atlanten
$NMasc_es_as/anten~ss$ = $SS$ {<+NN><Masc>}:{}                      $NSgSuff_es$ | \
                              {<+NN><Masc>}:{<del(VC)|Pl>ant<SB>en} $NPlSuff_x$

% Index, Indexes, Indizes
$NMasc_es_ex/izes$ = {<+NN><Masc>}:{}                     $NSgSuff_es$ | \
                     {<+NN><Masc>}:{<del(VC)|Pl>iz<SB>es} $NPlSuff_x$

% Virus, Virusses, Viren
$NMasc_es_us/en~ss$ = $SS$ {<+NN><Masc>}:{}                   $NSgSuff_es$ | \
                           {<+NN><Masc>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Kaktus, Kaktusses, Kakteen
$NMasc_es_us/een~ss$ = $SS$ {<+NN><Masc>}:{}                    $NSgSuff_es$ | \
                            {<+NN><Masc>}:{<del(VC)|Pl>e<SB>en} $NPlSuff_x$

% Intimus, Intimusse, Intimi
$NMasc_es_us/i~ss$ = $SS$ {<+NN><Masc>}:{}                  $NSgSuff_es$ | \
                          {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NPlSuff_x$

% Wagen, Wagens, Wagen
$NMasc_s_x$ = {<+NN><Masc>}:{} $NSgSuff_s$ | \
              {<+NN><Masc>}:{} $NPlSuff_x$

% Garten, Gartens, Gärten
$NMasc_s_\$x$ = {<+NN><Masc>}:{}      $NSgSuff_s$ | \
                {<+NN><Masc>}:{<uml>} $NPlSuff_x$

% Engel, Engels, Engel; Dezember, Dezembers, Dezember
$NMasc_s_0$ = {<+NN><Masc>}:{} $NSgSuff_s$ | \
              {<+NN><Masc>}:{} $NPlSuff_0$

% Apfel, Apfels, Äpfel; Vater, Vaters, Väter; Schaden, Schadens, Schäden
$NMasc_s_\$$ = {<+NN><Masc>}:{}      $NSgSuff_s$ | \
               {<+NN><Masc>}:{<uml>} $NPlSuff_0$

% Drilling, Drillings, Drillinge
$NMasc_s_e$ = {<+NN><Masc>}:{}      $NSgSuff_s$ | \
              {<+NN><Masc>}:{<SB>e} $NPlSuff_0$

% Tenor, Tenors, Tenöre
$NMasc_s_\$e$ = {<+NN><Masc>}:{}           $NSgSuff_s$ | \
                {<+NN><Masc>}:{<uml><SB>e} $NPlSuff_0$

% Ski, Skis, Skier
$NMasc_s_er$ = {<+NN><Masc>}:{}       $NSgSuff_s$ | \
               {<+NN><Masc>}:{<SB>er} $NPlSuff_x$

% Irrtum, Irrtums, Irrtümer
$NMasc_s_\$er$ = {<+NN><Masc>}:{}            $NSgSuff_s$ | \
                 {<+NN><Masc>}:{<uml><SB>er} $NPlSuff_0$

% Zeh, Zehs, Zehen
$NMasc_s_en$ = {<+NN><Masc>}:{}       $NSgSuff_s$ | \
               {<+NN><Masc>}:{<SB>en} $NPlSuff_x$

% Kanon, Kanons, Kanones
$NMasc_s_es$ = {<+NN><Masc>}:{}       $NSgSuff_s$ | \
               {<+NN><Masc>}:{<SB>es} $NPlSuff_x$

% Muskel, Muskels, Muskeln; See, Sees, Seen
$NMasc_s_n$ = {<+NN><Masc>}:{}      $NSgSuff_s$ | \
              {<+NN><Masc>}:{<SB>n} $NPlSuff_x$

% Embryo, Embryos, Embryonen (masculine)
$NMasc_s_nen$ = {<+NN><Masc>}:{}        $NSgSuff_s$ | \
                {<+NN><Masc>}:{n<SB>en} $NPlSuff_x$

% Chef, Chefs, Chefs; Bankier, Bankiers, Bankiers
$NMasc_s_s$ = {<+NN><Masc>}:{}      $NSgSuff_s$ | \
              {<+NN><Masc>}:{<SB>s} $NPlSuff_x$

% Carabiniere, Carabinieres, Carabinieri
$NMasc_s_e/i$ = {<+NN><Masc>}:{}                  $NSgSuff_s$ | \
                {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NPlSuff_x$

% Saldo, Saldos, Salden
$NMasc_s_o/en$ = {<+NN><Masc>}:{}                   $NSgSuff_s$ | \
                 {<+NN><Masc>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Espresso, Espressos, Espressi
$NMasc_s_o/i$ = {<+NN><Masc>}:{}                  $NSgSuff_s$ | \
                {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NPlSuff_x$

% Fels, Felsen, Felsen; Mensch, Menschen, Menschen
$NMasc_en_en$ = {<+NN><Masc>}:{}       $NSgSuff_en$ | \
                {<+NN><Masc>}:{<SB>en} $NPlSuff_x$

% Affe, Affen, Affen; Bauer, Bauern, Bauern
$NMasc_n_n$ = {<+NN><Masc>}:{}      $NSgSuff_n$ | \
              {<+NN><Masc>}:{<SB>n} $NPlSuff_x$

% Name, Namens, Namen; Buchstabe, Buchstabens, Buchstaben
$NMasc_ns_n$ = {<+NN><Masc>}:{}      $NSgSuff_ns$ | \
               {<+NN><Masc>}:{<SB>n} $NPlSuff_x$

% Schade, Schadens, Schäden
$NMasc_ns_\$n$ = {<+NN><Masc>}:{}           $NSgSuff_ns$ | \
                 {<+NN><Masc>}:{<uml><SB>n} $NPlSuff_x$

% Beamte(r); Gefreite(r)
$NMasc-Adj$ = {<+NN><Masc><Nom><Sg><St>}:{<SB>er} | \
              {<+NN><Masc><Acc><Sg><St>}:{<SB>en} | \
              {<+NN><Masc><Dat><Sg><St>}:{<SB>em} | \
              {<+NN><Masc><Gen><Sg><St>}:{<SB>en} | \
              {<+NN><Masc><Nom><Pl><St>}:{<SB>e}  | \
              {<+NN><Masc><Acc><Pl><St>}:{<SB>e}  | \
              {<+NN><Masc><Dat><Pl><St>}:{<SB>en} | \
              {<+NN><Masc><Gen><Pl><St>}:{<SB>er} | \
              {<+NN><Masc><Nom><Sg><Wk>}:{<SB>e}  | \
              {<+NN><Masc><Acc><Sg><Wk>}:{<SB>en} | \
              {<+NN><Masc><Dat><Sg><Wk>}:{<SB>en} | \
              {<+NN><Masc><Gen><Sg><Wk>}:{<SB>en} | \
              {<+NN><Masc><Nom><Pl><Wk>}:{<SB>en} | \
              {<+NN><Masc><Acc><Pl><Wk>}:{<SB>en} | \
              {<+NN><Masc><Dat><Pl><Wk>}:{<SB>en} | \
              {<+NN><Masc><Gen><Pl><Wk>}:{<SB>en}


% neuter nouns

% Abseits, Abseits
$NNeut/Sg_0$ = {<+NN><Neut>}:{} $NSgSuff_0$

% Ausland, Ausland(e)s
$NNeut/Sg_es$ = {<+NN><Neut>}:{} $NSgSuff_es$

% Verständnis, Verständnisses
$NNeut/Sg_es~ss$ = $SS$ {<+NN><Neut>}:{} $NSgSuff_es$

% Abitur, Abiturs
$NNeut/Sg_s$ = {<+NN><Neut>}:{} $NSgSuff_s$

% Pluraliatantum (suppletive plural)
$NNeut/Pl_x$ = {<+NN><Neut>}:{} $NPlSuff_x$

% Viecher (suppletive plural)
$NNeut/Pl_0$ = {<+NN><Neut>}:{} $NPlSuff_0$

% Relais, Relais, Relais
$NNeut_0_x$ = {<+NN><Neut>}:{} $NSgSuff_0$ | \
              {<+NN><Neut>}:{} $NPlSuff_x$

% Gefolge, Gefolge, Gefolge
$NNeut_0_0$ = {<+NN><Neut>}:{} $NSgSuff_0$ | \
              {<+NN><Neut>}:{} $NPlSuff_0$

% Bakschisch, Bakschisch, Bakschische
$NNeut_0_e$ = {<+NN><Neut>}:{}      $NSgSuff_0$ | \
              {<+NN><Neut>}:{<SB>e} $NPlSuff_0$

% Rhinozeros, Rhinozeros, Rhinozerosse
$NNeut_0_e~ss$ = $SS$ $NNeut_0_e$

% Remis, Remis, Remisen
$NNeut_0_en$ = {<+NN><Neut>}:{}       $NSgSuff_0$ | \
               {<+NN><Neut>}:{<SB>en} $NPlSuff_x$

% Sandwich, Sandwich, Sandwiches (neuter)
$NNeut_0_es$ = {<+NN><Neut>}:{}       $NSgSuff_0$ | \
               {<+NN><Neut>}:{<SB>es} $NPlSuff_x$

% Embryo, Embryo, Embryonen (neuter)
$NNeut_0_nen$ = {<+NN><Neut>}:{}        $NSgSuff_0$ | \
                {<+NN><Neut>}:{n<SB>en} $NPlSuff_x$

% College, College, Colleges
$NNeut_0_s$ = {<+NN><Neut>}:{}      $NSgSuff_0$ | \
              {<+NN><Neut>}:{<SB>s} $NPlSuff_x$

% Komma, Komma, Kommata
$NNeut_0_a/ata$ = {<+NN><Neut>}:{}       $NSgSuff_0$ | \
                  {<+NN><Neut>}:{t<SB>a} $NPlSuff_x$

% Dogma, Dogma, Dogmen
$NNeut_0_a/en$ = {<+NN><Neut>}:{}                   $NSgSuff_0$ | \
                 {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Determinans, Determinans, Determinantien
$NNeut_0_ans/antien$ = {<+NN><Neut>}:{}                       $NSgSuff_0$ | \
                       {<+NN><Neut>}:{<del(VC)|Pl>anti<SB>en} $NPlSuff_x$

% Stimulans, Stimulans, Stimulanzien
$NNeut_0_ans/anzien$ = {<+NN><Neut>}:{}                       $NSgSuff_0$ | \
                       {<+NN><Neut>}:{<del(VC)|Pl>anzi<SB>en} $NPlSuff_x$

% Ricercare, Ricercare, Ricercari
$NNeut_0_e/i$ = {<+NN><Neut>}:{}                  $NSgSuff_0$ | \
                {<+NN><Neut>}:{<del(VC)|Pl><SB>i} $NPlSuff_x$

% Examen, Examen, Examina
$NNeut_0_en/ina$ = {<+NN><Neut>}:{}                    $NSgSuff_0$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl>in<SB>a} $NPlSuff_x$

% Reagens, Reagens, Reagenzien
$NNeut_0_ens/enzien$ = {<+NN><Neut>}:{}                       $NSgSuff_0$ | \
                       {<+NN><Neut>}:{<del(VC)|Pl>enzi<SB>en} $NPlSuff_x$

% Konto, Konto, Konten
$NNeut_0_o/en$ = {<+NN><Neut>}:{}                   $NSgSuff_0$ | \
                 {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Intermezzo, Intermezzo, Intermezzi
$NNeut_0_o/i$ = {<+NN><Neut>}:{}                  $NSgSuff_0$ | \
                {<+NN><Neut>}:{<del(VC)|Pl><SB>i} $NPlSuff_x$

% Oxymoron, Oxymoron, Oxymora
$NNeut_0_on/a$ = {<+NN><Neut>}:{}                  $NSgSuff_0$ | \
                 {<+NN><Neut>}:{<del(VC)|Pl><SB>a} $NPlSuff_x$

% Stadion, Stadion, Stadien
$NNeut_0_on/en$ = {<+NN><Neut>}:{}                   $NSgSuff_0$ | \
                  {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Aktivum, Aktivum, Aktiva
$NNeut_0_um/a$ = {<+NN><Neut>}:{}                  $NSgSuff_0$ | \
                 {<+NN><Neut>}:{<del(VC)|Pl><SB>a} $NPlSuff_x$

% Museum, Museum, Museen
$NNeut_0_um/en$ = {<+NN><Neut>}:{}                   $NSgSuff_0$ | \
                  {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Virus, Virus, Viren; Epos, Epos, Epen
$NNeut_0_us/en$ = {<+NN><Neut>}:{}                   $NSgSuff_0$ | \
                  {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Genus, Genus, Genera
$NNeut_0_us/era$ = {<+NN><Neut>}:{}                    $NSgSuff_0$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl>er<SB>a} $NPlSuff_x$

% Tempus, Tempus, Tempora
$NNeut_0_us/ora$ = {<+NN><Neut>}:{}                    $NSgSuff_0$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl>or<SB>a} $NPlSuff_x$

% Spiel, Spiel(e)s, Spiele; Bakschisch, Bakschisch(e)s, Bakschische
$NNeut_es_e$ = {<+NN><Neut>}:{}      $NSgSuff_es$ | \
               {<+NN><Neut>}:{<SB>e} $NPlSuff_0$

% Zeugnis, Zeugnisses, Zeugnisse; Rhinozeros, Rhinozerosses, Rhinozerosse
$NNeut_es_e~ss$ = $SS$ $NNeut_es_e$

% Floß, Floßes, Flöße
$NNeut_es_\$e$ = {<+NN><Neut>}:{}           $NSgSuff_es$ | \
                 {<+NN><Neut>}:{<uml><SB>e} $NPlSuff_0$

% Schild, Schild(e)s, Schilder
$NNeut_es_er$ = {<+NN><Neut>}:{}       $NSgSuff_es$ | \
                {<+NN><Neut>}:{<SB>er} $NPlSuff_0$

% Buch, Buch(e)s, Bücher
$NNeut_es_\$er$ = {<+NN><Neut>}:{}            $NSgSuff_es$ | \
                  {<+NN><Neut>}:{<uml><SB>er} $NPlSuff_0$

% Bett, Bett(e)s, Betten
$NNeut_es_en$ = {<+NN><Neut>}:{}       $NSgSuff_es$ | \
                {<+NN><Neut>}:{<SB>en} $NPlSuff_x$

% Match, Match(e)s, Matches
$NNeut_es_es$ = {<+NN><Neut>}:{}       $NSgSuff_es$ | \
                {<+NN><Neut>}:{<SB>es} $NPlSuff_x$

% Tablett, Tablett(e)s, Tabletts
$NNeut_es_s$ = {<+NN><Neut>}:{}      $NSgSuff_es$ | \
               {<+NN><Neut>}:{<SB>s} $NPlSuff_x$

% Indiz, Indizes, Indizien
$NNeut_es_ien$ = {<+NN><Neut>}:{}        $NSgSuff_es$ | \
                 {<+NN><Neut>}:{i<SB>en} $NPlSuff_x$

% Almosen, Almosens, Almosen
$NNeut_s_x$ = {<+NN><Neut>}:{} $NSgSuff_s$ | \
              {<+NN><Neut>}:{} $NPlSuff_x$

% Feuer, Feuers, Feuer; Gefolge, Gefolges, Gefolge
$NNeut_s_0$ = {<+NN><Neut>}:{} $NSgSuff_s$ | \
              {<+NN><Neut>}:{} $NPlSuff_0$

% Kloster, Klosters, Klöster
$NNeut_s_\$$ = {<+NN><Neut>}:{}      $NSgSuff_s$ | \
               {<+NN><Neut>}:{<uml>} $NPlSuff_0$

% Reflexiv, Reflexivs, Reflexiva
$NNeut_s_a$ = {<+NN><Neut>}:{}      $NSgSuff_s$ | \
              {<+NN><Neut>}:{<SB>a} $NPlSuff_x$

% Dreieck, Dreiecks, Dreiecke
$NNeut_s_e$ = {<+NN><Neut>}:{}      $NSgSuff_s$ | \
              {<+NN><Neut>}:{<SB>e} $NPlSuff_0$

% Spital, Spitals, Spitäler
$NNeut_s_\$er$ = {<+NN><Neut>}:{}            $NSgSuff_s$ | \
                 {<+NN><Neut>}:{<uml><SB>er} $NPlSuff_0$

% Juwel, Juwels, Juwelen
$NNeut_s_en$ = {<+NN><Neut>}:{}       $NSgSuff_s$ | \
               {<+NN><Neut>}:{<SB>en} $NPlSuff_x$

% Auge, Auges, Augen
$NNeut_s_n$ = {<+NN><Neut>}:{}      $NSgSuff_s$ | \
              {<+NN><Neut>}:{<SB>n} $NPlSuff_x$

% Embryo, Embryos, Embryonen (neuter)
$NNeut_s_nen$ = {<+NN><Neut>}:{}        $NSgSuff_s$ | \
                {<+NN><Neut>}:{n<SB>en} $NPlSuff_x$

% Adverb, Adverbs, Adverbien
$NNeut_s_ien$ = {<+NN><Neut>}:{}        $NSgSuff_s$ | \
                {<+NN><Neut>}:{i<SB>en} $NPlSuff_x$

% Sofa, Sofas, Sofas; College, Colleges, Colleges
$NNeut_s_s$ = {<+NN><Neut>}:{}      $NSgSuff_s$ | \
              {<+NN><Neut>}:{<SB>s} $NPlSuff_x$

% Komma, Kommas, Kommata
$NNeut_s_a/ata$ = {<+NN><Neut>}:{}       $NSgSuff_s$ | \
                  {<+NN><Neut>}:{t<SB>a} $NPlSuff_x$

% Dogma, Dogmas, Dogmen
$NNeut_s_a/en$ = {<+NN><Neut>}:{}                   $NSgSuff_s$ | \
                 {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Ricercare, Ricercares, Ricercari
$NNeut_s_e/i$ = {<+NN><Neut>}:{}                  $NSgSuff_s$ | \
                {<+NN><Neut>}:{<del(VC)|Pl><SB>i} $NPlSuff_x$

% Examen, Examens, Examina
$NNeut_s_en/ina$ = {<+NN><Neut>}:{}                    $NSgSuff_s$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl>in<SB>a} $NPlSuff_x$

% Konto, Kontos, Konten
$NNeut_s_o/en$ = {<+NN><Neut>}:{}                   $NSgSuff_s$ | \
                 {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Intermezzo, Intermezzos, Intermezzi
$NNeut_s_o/i$ = {<+NN><Neut>}:{}                  $NSgSuff_s$ | \
                {<+NN><Neut>}:{<del(VC)|Pl><SB>i} $NPlSuff_x$

% Oxymoron, Oxymorons, Oxymora
$NNeut_s_on/a$ = {<+NN><Neut>}:{}                  $NSgSuff_s$ | \
                 {<+NN><Neut>}:{<del(VC)|Pl><SB>a} $NPlSuff_x$

% Stadion, Stadions, Stadien
$NNeut_s_on/en$ = {<+NN><Neut>}:{}                   $NSgSuff_s$ | \
                  {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Aktivum, Aktivums, Aktiva
$NNeut_s_um/a$ = {<+NN><Neut>}:{}                  $NSgSuff_s$ | \
                 {<+NN><Neut>}:{<del(VC)|Pl><SB>a} $NPlSuff_x$

% Museum, Museums, Museen
$NNeut_s_um/en$ = {<+NN><Neut>}:{}                   $NSgSuff_s$ | \
                  {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Herz, Herzens, Herzen
$NNeut_ens_en$ = {<+NN><Neut>}:{}       $NSgSuff_ens$ | \
                 {<+NN><Neut>}:{<SB>en} $NPlSuff_x$

% Innere(s)
$NNeut-Inner$ = {<+NN><Neut><Nom><Sg><St>}:{<SB>es} | \
                {<+NN><Neut><Acc><Sg><St>}:{<SB>es} | \
                {<+NN><Neut><Dat><Sg><St>}:{<SB>em} | \
                {<+NN><Neut><Gen><Sg><St>}:{<SB>en} | \
                {<+NN><Neut><Gen><Sg><St>}:{<SB>n}  | \
                {<+NN><Neut><Nom><Sg><Wk>}:{<SB>e}  | \
                {<+NN><Neut><Acc><Sg><Wk>}:{<SB>e}  | \
                {<+NN><Neut><Dat><Sg><Wk>}:{<SB>en} | \
                {<+NN><Neut><Dat><Sg><Wk>}:{<SB>n}  | \
                {<+NN><Neut><Gen><Sg><Wk>}:{<SB>en} | \
                {<+NN><Neut><Gen><Sg><Wk>}:{<SB>n}

% Deutsche(s)
$NNeut-Adj/Sg$ = {<+NN><Neut><Nom><Sg><St>}:{<SB>es} | \
                 {<+NN><Neut><Acc><Sg><St>}:{<SB>es} | \
                 {<+NN><Neut><Dat><Sg><St>}:{<SB>em} | \
                 {<+NN><Neut><Gen><Sg><St>}:{<SB>en} | \
                 {<+NN><Neut><Nom><Sg><Wk>}:{<SB>e}  | \
                 {<+NN><Neut><Acc><Sg><Wk>}:{<SB>e}  | \
                 {<+NN><Neut><Dat><Sg><Wk>}:{<SB>en} | \
                 {<+NN><Neut><Gen><Sg><Wk>}:{<SB>en}

% Junge(s) ('young animal')
$NNeut-Adj$ = {<+NN><Neut><Nom><Sg><St>}:{<SB>es} | \
              {<+NN><Neut><Acc><Sg><St>}:{<SB>es} | \
              {<+NN><Neut><Dat><Sg><St>}:{<SB>em} | \
              {<+NN><Neut><Gen><Sg><St>}:{<SB>en} | \
              {<+NN><Neut><Nom><Pl><St>}:{<SB>e}  | \
              {<+NN><Neut><Acc><Pl><St>}:{<SB>e}  | \
              {<+NN><Neut><Dat><Pl><St>}:{<SB>en} | \
              {<+NN><Neut><Gen><Pl><St>}:{<SB>er} | \
              {<+NN><Neut><Nom><Sg><Wk>}:{<SB>e}  | \
              {<+NN><Neut><Acc><Sg><Wk>}:{<SB>e}  | \
              {<+NN><Neut><Dat><Sg><Wk>}:{<SB>en} | \
              {<+NN><Neut><Gen><Sg><Wk>}:{<SB>en} | \
              {<+NN><Neut><Nom><Pl><Wk>}:{<SB>en} | \
              {<+NN><Neut><Acc><Pl><Wk>}:{<SB>en} | \
              {<+NN><Neut><Dat><Pl><Wk>}:{<SB>en} | \
              {<+NN><Neut><Gen><Pl><Wk>}:{<SB>en}


% feminine nouns

% Wut, Wut
$NFem/Sg_0$ = {<+NN><Fem>}:{} $NSgSuff_0$

% Anchorwomen (suppletive plural)
$NFem/Pl_x$ = {<+NN><Fem>}:{} $NPlSuff_x$

% Ananas, Ananas, Ananas
$NFem_0_x$ = {<+NN><Fem>}:{} $NSgSuff_0$ | \
             {<+NN><Fem>}:{} $NPlSuff_x$

% Randale, Randale, Randale
$NFem_0_0$ = {<+NN><Fem>}:{} $NSgSuff_0$ | \
             {<+NN><Fem>}:{} $NPlSuff_0$

% Mutter, Mutter, Mütter
$NFem_0_\$$ = {<+NN><Fem>}:{}      $NSgSuff_0$ | \
              {<+NN><Fem>}:{<uml>} $NPlSuff_0$

% Drangsal, Drangsal, Drangsale; Retina, Retina, Retinae
$NFem_0_e$ = {<+NN><Fem>}:{}      $NSgSuff_0$ | \
             {<+NN><Fem>}:{<SB>e} $NPlSuff_0$

% Kenntnis, Kenntnis, Kenntnisse
$NFem_0_e~ss$ = $SS$ $NFem_0_e$

% Wand, Wand, Wände
$NFem_0_\$e$ = {<+NN><Fem>}:{}           $NSgSuff_0$ | \
               {<+NN><Fem>}:{<uml><SB>e} $NPlSuff_0$

% Frau, Frau, Frauen; Arbeit, Arbeit, Arbeiten
$NFem_0_en$ = {<+NN><Fem>}:{}       $NSgSuff_0$ | \
              {<+NN><Fem>}:{<SB>en} $NPlSuff_x$

% Werkstatt, Werkstatt, Werkstätten
$NFem_0_\$en$ = {<+NN><Fem>}:{}            $NSgSuff_0$ | \
                {<+NN><Fem>}:{<uml><SB>en} $NPlSuff_x$

% Hilfe, Hilfe, Hilfen; Tafel, Tafel, Tafeln
$NFem_0_n$ = {<+NN><Fem>}:{}      $NSgSuff_0$ | \
             {<+NN><Fem>}:{<SB>n} $NPlSuff_x$

% Smartwatch, Smartwatch, Smartwatches
$NFem_0_es$ = {<+NN><Fem>}:{}       $NSgSuff_0$ | \
              {<+NN><Fem>}:{<SB>es} $NPlSuff_x$

% Oma, Oma, Omas
$NFem_0_s$ = {<+NN><Fem>}:{}      $NSgSuff_0$ | \
             {<+NN><Fem>}:{<SB>s} $NPlSuff_x$

% Algebra, Algebra, Algebren; Firma, Firma, Firmen
$NFem_0_a/en$ = {<+NN><Fem>}:{}                   $NSgSuff_0$ | \
                {<+NN><Fem>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Phalanx, Phalanx, Phalangen
$NFem_0_anx/angen$ = {<+NN><Fem>}:{}                      $NSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>ang<SB>en} $NPlSuff_x$

% Minestrone, Minestrone, Minestroni
$NFem_0_e/i$ = {<+NN><Fem>}:{}                  $NSgSuff_0$ | \
               {<+NN><Fem>}:{<del(VC)|Pl><SB>i} $NPlSuff_x$

% Lex, Lex, Leges
$NFem_0_ex/eges$ = {<+NN><Fem>}:{}                     $NSgSuff_0$ | \
                   {<+NN><Fem>}:{<del(VC)|Pl>eg<SB>es} $NPlSuff_x$

% Basis, Basis, Basen
$NFem_0_is/en$ = {<+NN><Fem>}:{}                   $NSgSuff_0$ | \
                 {<+NN><Fem>}:{<del(VC)|Pl><SB>en} $NPlSuff_x$

% Neuritis, Neuritis, Neuritiden
$NFem_0_is/iden$ = {<+NN><Fem>}:{}                     $NSgSuff_0$ | \
                   {<+NN><Fem>}:{<del(VC)|Pl>id<SB>en} $NPlSuff_x$

% Matrix, Matrix, Matrizen
$NFem_0_ix/izen$ = {<+NN><Fem>}:{}                     $NSgSuff_0$ | \
                   {<+NN><Fem>}:{<del(VC)|Pl>iz<SB>en} $NPlSuff_x$

% Radix, Radix, Radizes
$NFem_0_ix/izes$ = {<+NN><Fem>}:{}                     $NSgSuff_0$ | \
                   {<+NN><Fem>}:{<del(VC)|Pl>iz<SB>es} $NPlSuff_x$

% Freundin, Freundin, Freundinnen
$NFem-in$ = {<+NN><Fem>}:{}        $NSgSuff_0$ | \
            {<+NN><Fem>}:{n<SB>en} $NPlSuff_x$

% Frauenbeauftragte; Illustrierte
$NFem-Adj$ = {<+NN><Fem><Nom><Sg><St>}:{<SB>e}  | \
             {<+NN><Fem><Acc><Sg><St>}:{<SB>e}  | \
             {<+NN><Fem><Dat><Sg><St>}:{<SB>er} | \
             {<+NN><Fem><Gen><Sg><St>}:{<SB>er} | \
             {<+NN><Fem><Nom><Pl><St>}:{<SB>e}  | \
             {<+NN><Fem><Acc><Pl><St>}:{<SB>e}  | \
             {<+NN><Fem><Dat><Pl><St>}:{<SB>en} | \
             {<+NN><Fem><Gen><Pl><St>}:{<SB>er} | \
             {<+NN><Fem><Nom><Sg><Wk>}:{<SB>e}  | \
             {<+NN><Fem><Acc><Sg><Wk>}:{<SB>e}  | \
             {<+NN><Fem><Dat><Sg><Wk>}:{<SB>en} | \
             {<+NN><Fem><Gen><Sg><Wk>}:{<SB>en} | \
             {<+NN><Fem><Nom><Pl><Wk>}:{<SB>en} | \
             {<+NN><Fem><Acc><Pl><Wk>}:{<SB>en} | \
             {<+NN><Fem><Dat><Pl><Wk>}:{<SB>en} | \
             {<+NN><Fem><Gen><Pl><Wk>}:{<SB>en}


% pluralia tantum

% Kosten
$NNoGend/Pl_x$ = {<+NN><NoGend>}:{} $NPlSuff_x$

% Leute
$NNoGend/Pl_0$ = {<+NN><NoGend>}:{} $NPlSuff_0$


% proper names

$NameMasc_0$ = {<+NPROP><Masc>}:{} $NSgSuff_0$

% Andreas, Andreas'
$NameMasc_apos$ = {<+NPROP><Masc>}:{} $NSgSuff_0$ | \
                  {<+NPROP><Masc><Gen><Sg>}:{<SB>’}

$NameMasc_es$ = {<+NPROP><Masc>}:{} $NSgSuff_es$

$NameMasc_s$ = {<+NPROP><Masc>}:{} $NSgSuff_s$

$NameNeut_0$ = {<+NPROP><Neut>}:{} $NSgSuff_0$

% Paris, Paris'
$NameNeut_apos$ = {<+NPROP><Neut>}:{} $NSgSuff_0$ | \
                  {<+NPROP><Neut><Gen><Sg>}:{<SB>’}

$NameNeut_es$ = {<+NPROP><Neut>}:{} $NSgSuff_es$

$NameNeut_s$ = {<+NPROP><Neut>}:{} $NSgSuff_s$

$NameFem_0$ = {<+NPROP><Fem>}:{} $NSgSuff_0$

% Felicitas, Felicitas'
$NameFem_apos$ = {<+NPROP><Fem>}:{} $NSgSuff_0$ | \
                 {<+NPROP><Fem><Gen><Sg>}:{<SB>’}

$NameFem_s$ = {<+NPROP><Fem>}:{} $NSgSuff_s$

$NameNoGend/Pl_x$ = {<+NPROP><NoGend>}:{} $NPlSuff_x$

$NameNoGend/Pl_0$ = {<+NPROP><NoGend>}:{} $NPlSuff_0$

% family names ending in -s, -z
$Name-Fam_0$ = {<+NPROP><NoGend>}:{}        $NSgSuff_0$ | \
               {<+NPROP><NoGend>}:{en<SB>s} $NPlSuff_x$

% family names
$Name-Fam_s$ = {<+NPROP><NoGend>}:{}      $NSgSuff_s$ | \
               {<+NPROP><NoGend>}:{<SB>s} $NPlSuff_x$


% adjectives

$AdjInflSuff$ = {<Attr/Subst><Masc><Nom><Sg><St>}:{<SB>er}   | \
                {<Attr/Subst><Masc><Acc><Sg><St>}:{<SB>en}   | \
                {<Attr/Subst><Masc><Dat><Sg><St>}:{<SB>em}   | \
                {<Attr/Subst><Masc><Gen><Sg><St>}:{<SB>en}   | \
                {<Attr/Subst><Neut><Nom><Sg><St>}:{<SB>es}   | \
                {<Attr/Subst><Neut><Acc><Sg><St>}:{<SB>es}   | \
                {<Attr/Subst><Neut><Dat><Sg><St>}:{<SB>em}   | \
                {<Attr/Subst><Neut><Gen><Sg><St>}:{<SB>en}   | \
                {<Attr/Subst><Fem><Nom><Sg><St>}:{<SB>e}     | \
                {<Attr/Subst><Fem><Acc><Sg><St>}:{<SB>e}     | \
                {<Attr/Subst><Fem><Dat><Sg><St>}:{<SB>er}    | \
                {<Attr/Subst><Fem><Gen><Sg><St>}:{<SB>er}    | \
                {<Attr/Subst><NoGend><Nom><Pl><St>}:{<SB>e}  | \
                {<Attr/Subst><NoGend><Acc><Pl><St>}:{<SB>e}  | \
                {<Attr/Subst><NoGend><Dat><Pl><St>}:{<SB>en} | \
                {<Attr/Subst><NoGend><Gen><Pl><St>}:{<SB>er} | \
                {<Attr/Subst><Masc><Nom><Sg><Wk>}:{<SB>e}    | \
                {<Attr/Subst><Masc><Acc><Sg><Wk>}:{<SB>en}   | \
                {<Attr/Subst><Masc><Dat><Sg><Wk>}:{<SB>en}   | \
                {<Attr/Subst><Masc><Gen><Sg><Wk>}:{<SB>en}   | \
                {<Attr/Subst><Neut><Nom><Sg><Wk>}:{<SB>e}    | \
                {<Attr/Subst><Neut><Acc><Sg><Wk>}:{<SB>e}    | \
                {<Attr/Subst><Neut><Dat><Sg><Wk>}:{<SB>en}   | \
                {<Attr/Subst><Neut><Gen><Sg><Wk>}:{<SB>en}   | \
                {<Attr/Subst><Fem><Nom><Sg><Wk>}:{<SB>e}     | \
                {<Attr/Subst><Fem><Acc><Sg><Wk>}:{<SB>e}     | \
                {<Attr/Subst><Fem><Dat><Sg><Wk>}:{<SB>en}    | \
                {<Attr/Subst><Fem><Gen><Sg><Wk>}:{<SB>en}    | \
                {<Attr/Subst><NoGend><Nom><Pl><Wk>}:{<SB>en} | \
                {<Attr/Subst><NoGend><Acc><Pl><Wk>}:{<SB>en} | \
                {<Attr/Subst><NoGend><Dat><Pl><Wk>}:{<SB>en} | \
                {<Attr/Subst><NoGend><Gen><Pl><Wk>}:{<SB>en}

$AdjInflSuff-n$ = {<Attr/Subst><Masc><Acc><Sg><St>}:{<SB>n}   | \
                  {<Attr/Subst><Masc><Gen><Sg><St>}:{<SB>n}   | \
                  {<Attr/Subst><Neut><Gen><Sg><St>}:{<SB>n}   | \
                  {<Attr/Subst><NoGend><Dat><Pl><St>}:{<SB>n} | \
                  {<Attr/Subst><Masc><Acc><Sg><Wk>}:{<SB>n}   | \
                  {<Attr/Subst><Masc><Dat><Sg><Wk>}:{<SB>n}   | \
                  {<Attr/Subst><Masc><Gen><Sg><Wk>}:{<SB>n}   | \
                  {<Attr/Subst><Neut><Dat><Sg><Wk>}:{<SB>n}   | \
                  {<Attr/Subst><Neut><Gen><Sg><Wk>}:{<SB>n}   | \
                  {<Attr/Subst><Fem><Dat><Sg><Wk>}:{<SB>n}    | \
                  {<Attr/Subst><Fem><Gen><Sg><Wk>}:{<SB>n}    | \
                  {<Attr/Subst><NoGend><Nom><Pl><Wk>}:{<SB>n} | \
                  {<Attr/Subst><NoGend><Acc><Pl><Wk>}:{<SB>n} | \
                  {<Attr/Subst><NoGend><Dat><Pl><Wk>}:{<SB>n} | \
                  {<Attr/Subst><NoGend><Gen><Pl><Wk>}:{<SB>n}

$AdjInflSuff-m$ = {<Attr/Subst><Masc><Dat><Sg><St>}:{<SB>m} | \
                  {<Attr/Subst><Neut><Dat><Sg><St>}:{<SB>m}

% lila; klasse
$AdjPos0$ = {<+ADJ><Pos><Pred/Adv>}:{} | \
            {<+ADJ><Pos><Attr><Invar>}:{}

% viel; wenig
$AdjPos0-viel$ = {<+ADJ><Pos><Pred/Adv>}:{} | \
                 {<+ADJ><Pos><Attr/Subst><Invar>}:{}

% innen; hoch
$AdjPosPred$ = {<+ADJ><Pos><Pred/Adv>}:{}

% zig
$AdjPos0Attr$ = {<+ADJ><Pos><Attr><Invar>}:{}

% Berliner ('related to Berlin')
$AdjPos0AttrSubst$ = {<+ADJ><Pos><Attr/Subst><Invar>}:{}

% derartig; famos; bloß
$AdjPos$ = {<+ADJ><Pos><Pred/Adv>}:{} | \
           {<+ADJ><Pos>}:{} $AdjInflSuff$

% vorig-; hoh-
$AdjPosAttr$ = {<+ADJ><Pos>}:{} $AdjInflSuff$

% ander-; ober-
$AdjPosAttr-er$ = {<+ADJ><Pos>}:{} $AdjInflSuff$             | \
                  {<+ADJ><Pos>}:{<del(e)|ADJ>} $AdjInflSuff$ | \
                  {<+ADJ><Pos>}:{} $AdjInflSuff-n$           | \
                  {<+ADJ><Pos>}:{} $AdjInflSuff-m$

% besser; höher
$AdjComp$ = {<+ADJ><Comp><Pred/Adv>}:{<SB>er} | \
            {<+ADJ><Comp>}:{<SB>er} $AdjInflSuff$

% mehr; weniger
$AdjComp0-mehr$ = {<+ADJ><Comp><Pred/Adv>}:{} | \
                  {<+ADJ><Comp><Attr/Subst><Invar>}:{}

% besten; höchsten
$AdjSup$ = {<+ADJ><Sup><Pred/Adv>}:{<SB>st<SB>en} | \
           {<+ADJ><Sup>}:{<SB>st} $AdjInflSuff$

% allerbesten; allerhöchsten
$AdjSup-aller$ = {<+ADJ><Sup><Pred/Adv>}:{<SB>st<SB>en} | \
                 {<+ADJ><Sup>}:{<SB>st} $AdjInflSuff$

% obersten
$AdjSupAttr$ = {<+ADJ><Sup>}:{<SB>st} $AdjInflSuff$

% faul, fauler, faulsten
$Adj_0$ = {<+ADJ><Pos><Pred/Adv>}:{}             | \
          {<+ADJ><Pos>}:{} $AdjInflSuff$         | \
          {<+ADJ><Comp><Pred/Adv>}:{<SB>er}      | \
          {<+ADJ><Comp>}:{<SB>er} $AdjInflSuff$  | \
          {<+ADJ><Sup><Pred/Adv>}:{<SB>st<SB>en} | \
          {<+ADJ><Sup>}:{<SB>st} $AdjInflSuff$

% bunt, bunter, buntesten
$Adj_e$ = {<+ADJ><Pos><Pred/Adv>}:{}              | \
          {<+ADJ><Pos>}:{} $AdjInflSuff$          | \
          {<+ADJ><Comp><Pred/Adv>}:{<SB>er}       | \
          {<+ADJ><Comp>}:{<SB>er} $AdjInflSuff$   | \
          {<+ADJ><Sup><Pred/Adv>}:{<SB>est<SB>en} | \
          {<+ADJ><Sup>}:{<SB>est} $AdjInflSuff$

% warm, wärmer, wärmsten
$Adj_\$$ = {<+ADJ><Pos><Pred/Adv>}:{}                  | \
           {<+ADJ><Pos>}:{} $AdjInflSuff$              | \
           {<+ADJ><Comp><Pred/Adv>}:{<uml><SB>er}      | \
           {<+ADJ><Comp>}:{<uml><SB>er} $AdjInflSuff$  | \
           {<+ADJ><Sup><Pred/Adv>}:{<uml><SB>st<SB>en} | \
           {<+ADJ><Sup>}:{<uml><SB>st} $AdjInflSuff$

% kalt, kälter, kältesten
$Adj_\$e$ = {<+ADJ><Pos><Pred/Adv>}:{}                   | \
            {<+ADJ><Pos>}:{} $AdjInflSuff$               | \
            {<+ADJ><Comp><Pred/Adv>}:{<uml><SB>er}       | \
            {<+ADJ><Comp>}:{<uml><SB>er} $AdjInflSuff$   | \
            {<+ADJ><Sup><Pred/Adv>}:{<uml><SB>est<SB>en} | \
            {<+ADJ><Sup>}:{<uml><SB>est} $AdjInflSuff$

% dunkel, dunkler, dunkelsten
$Adj-el_0$ = {}:{<del(e)|ADJ>} $Adj_0$                   | \
             {<+ADJ><Pos>}:{} $AdjInflSuff-n$ {<Old>}:{} | \ % cf. Duden-Grammatik (2016: § 494)
             {<+ADJ><Pos>}:{} $AdjInflSuff-m$ {<Old>}:{}     % cf. Duden-Grammatik (2016: § 494)

% dunkel, dünkler, dünkelsten (regional variant)
$Adj-el_\$$ = {}:{<del(e)|ADJ>} $Adj_\$$                 | \
              {<+ADJ><Pos>}:{} $AdjInflSuff-n$ {<Old>}:{} | \ % cf. Duden-Grammatik (2016: § 494)
              {<+ADJ><Pos>}:{} $AdjInflSuff-m$ {<Old>}:{}     % cf. Duden-Grammatik (2016: § 494)

% finster, finst(e)rer, finstersten
$Adj-er_0$ = $Adj_0$                                     | \
             {}:{<del(e)|ADJ>} $Adj_0$                   | \
             {<+ADJ><Pos>}:{} $AdjInflSuff-n$ {<Old>}:{} | \ % cf. Duden-Grammatik (2016: § 494)
             {<+ADJ><Pos>}:{} $AdjInflSuff-m$ {<Old>}:{}     % cf. Duden-Grammatik (2016: § 494)

% trocken, trock(e)ner, trockensten
$Adj-en_0$ = $Adj_0$ | \
             {}:{<del(e)|ADJ>} $Adj_0$

% deutsch; [das] Deutsch
$Adj-Lang$ = $Adj_0$ | \
             $NNeut/Sg_s$


% articles and pronouns

$ArtDefAttrSuff$ = {<Attr><Masc><Nom><Sg><St>}:{<SB>er}   | \
                   {<Attr><Masc><Acc><Sg><St>}:{<SB>en}   | \
                   {<Attr><Masc><Dat><Sg><St>}:{<SB>em}   | \
                   {<Attr><Masc><Gen><Sg><St>}:{<SB>es}   | \
                   {<Attr><Neut><Nom><Sg><St>}:{<SB>as}   | \
                   {<Attr><Neut><Acc><Sg><St>}:{<SB>as}   | \
                   {<Attr><Neut><Dat><Sg><St>}:{<SB>em}   | \
                   {<Attr><Neut><Gen><Sg><St>}:{<SB>es}   | \
                   {<Attr><Fem><Nom><Sg><St>}:{<SB>ie}    | \
                   {<Attr><Fem><Acc><Sg><St>}:{<SB>ie}    | \
                   {<Attr><Fem><Dat><Sg><St>}:{<SB>er}    | \
                   {<Attr><Fem><Gen><Sg><St>}:{<SB>er}    | \
                   {<Attr><NoGend><Nom><Pl><St>}:{<SB>ie} | \
                   {<Attr><NoGend><Acc><Pl><St>}:{<SB>ie} | \
                   {<Attr><NoGend><Dat><Pl><St>}:{<SB>en} | \
                   {<Attr><NoGend><Gen><Pl><St>}:{<SB>er}

$ArtDefSubstSuff$ = {<Subst><Masc><Nom><Sg><St>}:{<SB>er}     | \
                    {<Subst><Masc><Acc><Sg><St>}:{<SB>en}     | \
                    {<Subst><Masc><Dat><Sg><St>}:{<SB>em}     | \
                    {<Subst><Masc><Gen><Sg><St>}:{<SB>essen}  | \
                    {<Subst><Neut><Nom><Sg><St>}:{<SB>as}     | \
                    {<Subst><Neut><Acc><Sg><St>}:{<SB>as}     | \
                    {<Subst><Neut><Dat><Sg><St>}:{<SB>em}     | \
                    {<Subst><Neut><Gen><Sg><St>}:{<SB>essen}  | \
                    {<Subst><Fem><Nom><Sg><St>}:{<SB>ie}      | \
                    {<Subst><Fem><Acc><Sg><St>}:{<SB>ie}      | \
                    {<Subst><Fem><Dat><Sg><St>}:{<SB>er}      | \
                    {<Subst><Fem><Gen><Sg><St>}:{<SB>erer}    | \
                    {<Subst><Fem><Gen><Sg><St>}:{<SB>eren}    | \
                    {<Subst><NoGend><Nom><Pl><St>}:{<SB>ie}   | \
                    {<Subst><NoGend><Acc><Pl><St>}:{<SB>ie}   | \
                    {<Subst><NoGend><Dat><Pl><St>}:{<SB>enen} | \
                    {<Subst><NoGend><Gen><Pl><St>}:{<SB>erer} | \
                    {<Subst><NoGend><Gen><Pl><St>}:{<SB>eren}

$ArtDefSuff$ = $ArtDefAttrSuff$ | \
               $ArtDefSubstSuff$

$RelSuff$ = $ArtDefSubstSuff$

$DemDefSuff$ = $ArtDefSuff$

$DemSuff$ = {[<Attr><Subst>]<Masc><Nom><Sg><St>}:{<SB>er}   | \
            {[<Attr><Subst>]<Masc><Acc><Sg><St>}:{<SB>en}   | \
            {[<Attr><Subst>]<Masc><Dat><Sg><St>}:{<SB>em}   | \
            {[<Attr><Subst>]<Masc><Gen><Sg><St>}:{<SB>es}   | \
            {<Attr><Masc><Gen><Sg><St><NonSt>}:{<SB>en}     | \ % cf. Duden-Grammatik (2016: § 356, 379)
            {[<Attr><Subst>]<Neut><Nom><Sg><St>}:{<SB>es}   | \
            {[<Attr><Subst>]<Neut><Acc><Sg><St>}:{<SB>es}   | \
            {[<Attr><Subst>]<Neut><Dat><Sg><St>}:{<SB>em}   | \
            {[<Attr><Subst>]<Neut><Gen><Sg><St>}:{<SB>es}   | \
            {<Attr><Neut><Gen><Sg><St><NonSt>}:{<SB>en}     | \ % cf. Duden-Grammatik (2016: § 356, 379)
            {[<Attr><Subst>]<Fem><Nom><Sg><St>}:{<SB>e}     | \
            {[<Attr><Subst>]<Fem><Acc><Sg><St>}:{<SB>e}     | \
            {[<Attr><Subst>]<Fem><Dat><Sg><St>}:{<SB>er}    | \
            {[<Attr><Subst>]<Fem><Gen><Sg><St>}:{<SB>er}    | \
            {[<Attr><Subst>]<NoGend><Nom><Pl><St>}:{<SB>e}  | \
            {[<Attr><Subst>]<NoGend><Acc><Pl><St>}:{<SB>e}  | \
            {[<Attr><Subst>]<NoGend><Dat><Pl><St>}:{<SB>en} | \
            {[<Attr><Subst>]<NoGend><Gen><Pl><St>}:{<SB>er}

$DemSuff-dies$ = $DemSuff$ | \
                 {[<Attr><Subst>]<Neut><Nom><Sg><St>}:{} | \
                 {[<Attr><Subst>]<Neut><Acc><Sg><St>}:{}

$DemSuff-solch/St$ = $DemSuff$

$DemSuff-solch/Wk$ = {[<Attr><Subst>]<Masc><Nom><Sg><Wk>}:{<SB>e}    | \
                     {[<Attr><Subst>]<Masc><Acc><Sg><Wk>}:{<SB>en}   | \
                     {[<Attr><Subst>]<Masc><Dat><Sg><Wk>}:{<SB>en}   | \
                     {[<Attr><Subst>]<Masc><Gen><Sg><Wk>}:{<SB>en}   | \
                     {[<Attr><Subst>]<Neut><Nom><Sg><Wk>}:{<SB>e}    | \
                     {[<Attr><Subst>]<Neut><Acc><Sg><Wk>}:{<SB>e}    | \
                     {[<Attr><Subst>]<Neut><Dat><Sg><Wk>}:{<SB>en}   | \
                     {[<Attr><Subst>]<Neut><Gen><Sg><Wk>}:{<SB>en}   | \
                     {[<Attr><Subst>]<Fem><Nom><Sg><Wk>}:{<SB>e}     | \
                     {[<Attr><Subst>]<Fem><Acc><Sg><Wk>}:{<SB>e}     | \
                     {[<Attr><Subst>]<Fem><Dat><Sg><Wk>}:{<SB>en}    | \
                     {[<Attr><Subst>]<Fem><Gen><Sg><Wk>}:{<SB>en}    | \
                     {[<Attr><Subst>]<NoGend><Nom><Pl><Wk>}:{<SB>en} | \
                     {[<Attr><Subst>]<NoGend><Acc><Pl><Wk>}:{<SB>en} | \
                     {[<Attr><Subst>]<NoGend><Dat><Pl><Wk>}:{<SB>en} | \
                     {[<Attr><Subst>]<NoGend><Gen><Pl><Wk>}:{<SB>en}

$DemSuff-solch$ = $DemSuff-solch/St$ | \
                  $DemSuff-solch/Wk$ | \ % cf. Duden-Grammatik (2016: § 432)
                  {<Attr><Invar>}:{}

$DemSuff-alldem$ = {<Subst><Neut><Dat><Sg><St>}:{<SB>em}

$DemSuff0$ = {[<Attr><Subst>]<Invar>}:{}

$ArtDef-der+DemMascSuff$ = {<Nom><Sg><Wk>}:{<SB>e}

$ArtDef-den+DemMascSuff$ = {<Acc><Sg><Wk>}:{<SB>en}

$ArtDef-dem+DemMascSuff$ = {<Dat><Sg><Wk>}:{<SB>en}

$ArtDef-des+DemMascSuff$ = {<Gen><Sg><Wk>}:{<SB>en}

$ArtDef-das+DemNeutSuff$ = {<Nom><Sg><Wk>}:{<SB>e} | \
                           {<Acc><Sg><Wk>}:{<SB>e}

$ArtDef-dem+DemNeutSuff$ = {<Dat><Sg><Wk>}:{<SB>en}

$ArtDef-des+DemNeutSuff$ = {<Gen><Sg><Wk>}:{<SB>en}

$ArtDef-die+DemFemSuff$ = {<Nom><Sg><Wk>}:{<SB>e} | \
                          {<Acc><Sg><Wk>}:{<SB>e}

$ArtDef-der+DemFemSuff$ = {<Dat><Sg><Wk>}:{<SB>en} | \
                          {<Gen><Sg><Wk>}:{<SB>en}

$ArtDef-die+DemNoGendSuff$ = {<Nom><Pl><Wk>}:{<SB>en} | \
                             {<Acc><Pl><Wk>}:{<SB>en}

$ArtDef-den+DemNoGendSuff$ = {<Dat><Pl><Wk>}:{<SB>en}

$ArtDef-der+DemNoGendSuff$ = {<Gen><Pl><Wk>}:{<SB>en}

$WSuff-welch$ = $DemSuff-solch/St$ | \
                {<Attr><Invar>}:{}

$RelSuff-welch$ = $WSuff-welch$ % cf. Duden-Grammatik (2016: § 403)

$IndefSuff-welch$ = {<Subst><Masc><Nom><Sg><St>}:{<SB>er}   | \
                    {<Subst><Masc><Acc><Sg><St>}:{<SB>en}   | \
                    {<Subst><Masc><Dat><Sg><St>}:{<SB>em}   | \
                    {<Subst><Masc><Gen><Sg><St>}:{<SB>es}   | \
                    {<Subst><Neut><Nom><Sg><St>}:{<SB>es}   | \
                    {<Subst><Neut><Acc><Sg><St>}:{<SB>es}   | \
                    {<Subst><Neut><Dat><Sg><St>}:{<SB>em}   | \
                    {<Subst><Neut><Gen><Sg><St>}:{<SB>es}   | \
                    {<Subst><Fem><Nom><Sg><St>}:{<SB>e}     | \
                    {<Subst><Fem><Acc><Sg><St>}:{<SB>e}     | \
                    {<Subst><Fem><Dat><Sg><St>}:{<SB>er}    | \
                    {<Subst><Fem><Gen><Sg><St>}:{<SB>er}    | \
                    {<Subst><NoGend><Nom><Pl><St>}:{<SB>e}  | \
                    {<Subst><NoGend><Acc><Pl><St>}:{<SB>e}  | \
                    {<Subst><NoGend><Dat><Pl><St>}:{<SB>en} | \
                    {<Subst><NoGend><Gen><Pl><St>}:{<SB>er}

$IndefSuff-irgendwelch$ = $DemSuff-solch/St$

$IndefSuff-all$ = $DemSuff-solch/St$                           | \
                  {<Subst><Masc><Dat><Sg><Wk><NonSt>}:{<SB>en} | \ % cf. Duden-Grammatik (2016: § 411)
                  {<Subst><Neut><Dat><Sg><Wk><NonSt>}:{<SB>en} | \ % cf. Duden-Grammatik (2016: § 411)
                  {<Attr><Invar>}:{}

$IndefSuff-jed/St$ = {[<Attr><Subst>]<Masc><Nom><Sg><St>}:{<SB>er} | \
                     {[<Attr><Subst>]<Masc><Acc><Sg><St>}:{<SB>en} | \
                     {[<Attr><Subst>]<Masc><Dat><Sg><St>}:{<SB>em} | \
                     {[<Attr><Subst>]<Masc><Gen><Sg><St>}:{<SB>es} | \
                     {<Attr><Masc><Gen><Sg><St><NonSt>}:{<SB>en}   | \ % cf. Duden-Grammatik (2016: § 356, 422)
                     {[<Attr><Subst>]<Neut><Nom><Sg><St>}:{<SB>es} | \
                     {[<Attr><Subst>]<Neut><Acc><Sg><St>}:{<SB>es} | \
                     {[<Attr><Subst>]<Neut><Dat><Sg><St>}:{<SB>em} | \
                     {[<Attr><Subst>]<Neut><Gen><Sg><St>}:{<SB>es} | \
                     {<Attr><Neut><Gen><Sg><St><NonSt>}:{<SB>en}   | \ % cf. Duden-Grammatik (2016: § 356, 422)
                     {[<Attr><Subst>]<Fem><Nom><Sg><St>}:{<SB>e}   | \
                     {[<Attr><Subst>]<Fem><Acc><Sg><St>}:{<SB>e}   | \
                     {[<Attr><Subst>]<Fem><Dat><Sg><St>}:{<SB>er}  | \
                     {[<Attr><Subst>]<Fem><Gen><Sg><St>}:{<SB>er}

$IndefSuff-jed/Wk$ = {[<Attr><Subst>]<Masc><Nom><Sg><Wk>}:{<SB>e}  | \
                     {[<Attr><Subst>]<Masc><Acc><Sg><Wk>}:{<SB>en} | \
                     {[<Attr><Subst>]<Masc><Dat><Sg><Wk>}:{<SB>en} | \
                     {[<Attr><Subst>]<Masc><Gen><Sg><Wk>}:{<SB>en} | \
                     {[<Attr><Subst>]<Neut><Nom><Sg><Wk>}:{<SB>e}  | \
                     {[<Attr><Subst>]<Neut><Acc><Sg><Wk>}:{<SB>e}  | \
                     {[<Attr><Subst>]<Neut><Dat><Sg><Wk>}:{<SB>en} | \
                     {[<Attr><Subst>]<Neut><Gen><Sg><Wk>}:{<SB>en} | \
                     {[<Attr><Subst>]<Fem><Nom><Sg><Wk>}:{<SB>e}   | \
                     {[<Attr><Subst>]<Fem><Acc><Sg><Wk>}:{<SB>e}   | \
                     {[<Attr><Subst>]<Fem><Dat><Sg><Wk>}:{<SB>en}  | \
                     {[<Attr><Subst>]<Fem><Gen><Sg><Wk>}:{<SB>en}

$IndefSuff-jed$ = $IndefSuff-jed/St$ | \
                  $IndefSuff-jed/Wk$

$IndefSuff-jeglich$ = $DemSuff$ | \
                      $IndefSuff-jed/Wk$

$IndefSuff-saemtlich$ = $DemSuff-solch/St$ | \
                        $DemSuff-solch/Wk$ | \
                        {<Subst><Invar>}:{}

$IndefSuff-beid$ = {<Subst><Neut><Nom><Sg><St>}:{<SB>es}           | \
                   {<Subst><Neut><Acc><Sg><St>}:{<SB>es}           | \
                   {<Subst><Neut><Dat><Sg><St>}:{<SB>em}           | \
                   {<Subst><Neut><Gen><Sg><St>}:{<SB>es}           | \
                   {[<Attr><Subst>]<NoGend><Nom><Pl><St>}:{<SB>e}  | \
                   {[<Attr><Subst>]<NoGend><Acc><Pl><St>}:{<SB>e}  | \
                   {[<Attr><Subst>]<NoGend><Dat><Pl><St>}:{<SB>en} | \
                   {[<Attr><Subst>]<NoGend><Gen><Pl><St>}:{<SB>er} | \
                   {<Subst><Neut><Nom><Sg><Wk>}:{<SB>e}            | \
                   {<Subst><Neut><Acc><Sg><Wk>}:{<SB>e}            | \
                   {<Subst><Neut><Dat><Sg><Wk>}:{<SB>en}           | \
                   {<Subst><Neut><Gen><Sg><Wk>}:{<SB>en}           | \
                   {[<Attr><Subst>]<NoGend><Nom><Pl><Wk>}:{<SB>en} | \
                   {[<Attr><Subst>]<NoGend><Acc><Pl><Wk>}:{<SB>en} | \
                   {[<Attr><Subst>]<NoGend><Dat><Pl><Wk>}:{<SB>en} | \
                   {[<Attr><Subst>]<NoGend><Gen><Pl><Wk>}:{<SB>en}

$IndefSuff-einig$ = $DemSuff$

$IndefSuff-manch$ = $WSuff-welch$

$IndefSuff-mehrer$ = {[<Attr><Subst>]<Neut><Nom><Sg><St>}:{<SB>es}   | \
                     {[<Attr><Subst>]<Neut><Acc><Sg><St>}:{<SB>es}   | \
                     {[<Attr><Subst>]<NoGend><Nom><Pl><St>}:{<SB>e}  | \
                     {[<Attr><Subst>]<NoGend><Acc><Pl><St>}:{<SB>e}  | \
                     {[<Attr><Subst>]<NoGend><Dat><Pl><St>}:{<SB>en} | \
                     {[<Attr><Subst>]<NoGend><Gen><Pl><St>}:{<SB>er}

$IndefSuff0$ = {[<Attr><Subst>]<Invar>}:{}

$ArtIndefAttrSuff$ = {<Attr><Masc><Nom><Sg><NoInfl>}:{}     | \
                     {<Attr><Masc><Acc><Sg><St>}:{<SB>en}   | \
                     {<Attr><Masc><Dat><Sg><St>}:{<SB>em}   | \
                     {<Attr><Masc><Gen><Sg><St>}:{<SB>es}   | \
                     {<Attr><Neut><Nom><Sg><NoInfl>}:{}     | \
                     {<Attr><Neut><Acc><Sg><NoInfl>}:{}     | \
                     {<Attr><Neut><Dat><Sg><St>}:{<SB>em}   | \
                     {<Attr><Neut><Gen><Sg><St>}:{<SB>es}   | \
                     {<Attr><Fem><Nom><Sg><St>}:{<SB>e}     | \
                     {<Attr><Fem><Acc><Sg><St>}:{<SB>e}     | \
                     {<Attr><Fem><Dat><Sg><St>}:{<SB>er}    | \
                     {<Attr><Fem><Gen><Sg><St>}:{<SB>er}

$ArtIndefSubstSuff$ = {<Subst><Masc><Nom><Sg><St>}:{<SB>er} | \
                      {<Subst><Masc><Acc><Sg><St>}:{<SB>en} | \
                      {<Subst><Masc><Dat><Sg><St>}:{<SB>em} | \
                      {<Subst><Masc><Gen><Sg><St>}:{<SB>es} | \
                      {<Subst><Neut><Nom><Sg><St>}:{<SB>es} | \
                      {<Subst><Neut><Nom><Sg><St>}:{<SB>s}  | \
                      {<Subst><Neut><Acc><Sg><St>}:{<SB>es} | \
                      {<Subst><Neut><Acc><Sg><St>}:{<SB>s}  | \
                      {<Subst><Neut><Dat><Sg><St>}:{<SB>em} | \
                      {<Subst><Neut><Gen><Sg><St>}:{<SB>es} | \
                      {<Subst><Fem><Nom><Sg><St>}:{<SB>e}   | \
                      {<Subst><Fem><Acc><Sg><St>}:{<SB>e}   | \
                      {<Subst><Fem><Dat><Sg><St>}:{<SB>er}  | \
                      {<Subst><Fem><Gen><Sg><St>}:{<SB>er}

$ArtIndefSuff$ = $ArtIndefAttrSuff$ | \
                 $ArtIndefSubstSuff$

$IndefSuff-ein/St$ = $ArtIndefSubstSuff$

$IndefSuff-ein/Wk$ = {<Subst><Masc><Nom><Sg><Wk>}:{<SB>e}  | \
                     {<Subst><Masc><Acc><Sg><Wk>}:{<SB>en} | \
                     {<Subst><Masc><Dat><Sg><Wk>}:{<SB>en} | \
                     {<Subst><Masc><Gen><Sg><Wk>}:{<SB>en} | \
                     {<Subst><Neut><Nom><Sg><Wk>}:{<SB>e}  | \
                     {<Subst><Neut><Acc><Sg><Wk>}:{<SB>e}  | \
                     {<Subst><Neut><Dat><Sg><Wk>}:{<SB>en} | \
                     {<Subst><Neut><Gen><Sg><Wk>}:{<SB>en} | \
                     {<Subst><Fem><Nom><Sg><Wk>}:{<SB>e}   | \
                     {<Subst><Fem><Acc><Sg><Wk>}:{<SB>e}   | \
                     {<Subst><Fem><Dat><Sg><Wk>}:{<SB>en}  | \
                     {<Subst><Fem><Gen><Sg><Wk>}:{<SB>en}

$IndefSuff-ein$ = $IndefSuff-ein/St$ | \
                  $IndefSuff-ein/Wk$

$ArtNegAttrSuff$ = $ArtIndefAttrSuff$                          | \
                   {<Attr><Masc><Gen><Sg><St><NonSt>}:{<SB>en} | \ % cf. Duden-Grammatik (2016: § 356, 425)
                   {<Attr><Neut><Gen><Sg><St><NonSt>}:{<SB>en} | \ % cf. Duden-Grammatik (2016: § 356, 425)
                   {<Attr><NoGend><Nom><Pl><St>}:{<SB>e}       | \
                   {<Attr><NoGend><Acc><Pl><St>}:{<SB>e}       | \
                   {<Attr><NoGend><Dat><Pl><St>}:{<SB>en}      | \
                   {<Attr><NoGend><Gen><Pl><St>}:{<SB>er}

$ArtNegSubstSuff$ = $ArtIndefSubstSuff$                     | \
                    {<Subst><NoGend><Nom><Pl><St>}:{<SB>e}  | \
                    {<Subst><NoGend><Acc><Pl><St>}:{<SB>e}  | \
                    {<Subst><NoGend><Dat><Pl><St>}:{<SB>en} | \
                    {<Subst><NoGend><Gen><Pl><St>}:{<SB>er}

$ArtNegSuff$ =  $ArtNegAttrSuff$ | \
                $ArtNegSubstSuff$

$IndefSuff-kein$ = $ArtNegSubstSuff$

$PossSuff/St$ = $ArtNegSuff$

$PossSuff/Wk$ = {<Subst><Masc><Nom><Sg><Wk>}:{<SB>e}    | \
                {<Subst><Masc><Acc><Sg><Wk>}:{<SB>en}   | \
                {<Subst><Masc><Dat><Sg><Wk>}:{<SB>en}   | \
                {<Subst><Masc><Gen><Sg><Wk>}:{<SB>en}   | \
                {<Subst><Neut><Nom><Sg><Wk>}:{<SB>e}    | \
                {<Subst><Neut><Acc><Sg><Wk>}:{<SB>e}    | \
                {<Subst><Neut><Dat><Sg><Wk>}:{<SB>en}   | \
                {<Subst><Neut><Gen><Sg><Wk>}:{<SB>en}   | \
                {<Subst><Fem><Nom><Sg><Wk>}:{<SB>e}     | \
                {<Subst><Fem><Acc><Sg><Wk>}:{<SB>e}     | \
                {<Subst><Fem><Dat><Sg><Wk>}:{<SB>en}    | \
                {<Subst><Fem><Gen><Sg><Wk>}:{<SB>en}    | \
                {<Subst><NoGend><Nom><Pl><Wk>}:{<SB>en} | \
                {<Subst><NoGend><Acc><Pl><Wk>}:{<SB>en} | \
                {<Subst><NoGend><Dat><Pl><Wk>}:{<SB>en} | \
                {<Subst><NoGend><Gen><Pl><Wk>}:{<SB>en}

$PossSuff$ = $PossSuff/St$ | \
             $PossSuff/Wk$

$IProSuff0$ = {<Invar>}:{}

$IProSuff$ = {<Nom><Sg>}:{}       | \
             {<Acc><Sg>}:{<SB>en} | \
             {<Acc><Sg>}:{}       | \
             {<Dat><Sg>}:{<SB>em} | \
             {<Dat><Sg>}:{}       | \
             {<Gen><Sg>}:{<SB>es}

$IProSuff-jedermann$ = {<Nom><Sg>}:{} | \
                       {<Acc><Sg>}:{} | \
                       {<Dat><Sg>}:{} | \
                       {<Gen><Sg>}:{<SB>s}

$IProSuff-jedefrau$ = {<Nom><Sg>}:{} | \
                      {<Acc><Sg>}:{}

$IProSuff-jederfrau$ = {<Dat><Sg>}:{} | \
                       {<Gen><Sg>}:{}

$IProSuff-man$ = {<Nom><Sg>}:{}

$IProSuff-unsereiner$ = {<Nom><Sg>}:{<SB>er} | \ % cf. Duden-Grammatik (2016: § 433)
                        {<Acc><Sg>}:{<SB>en} | \
                        {<Dat><Sg>}:{<SB>em}

$PProNomSgSuff$ = {<Nom><Sg>}:{}

$PProAccSgSuff$ = {<Acc><Sg>}:{}

$PProDatSgSuff$ = {<Dat><Sg>}:{}

$PProGenSgSuff$ = {<Gen><Sg>}:{<SB>er} | \
                  {<Gen><Sg><Old>}:{} % cf. Duden-Grammatik (2016: § 363)

$PProNomPlSuff$ = {<Nom><Pl>}:{}

$PProAccPlSuff$ = {<Acc><Pl>}:{}

$PProDatPlSuff$ = {<Dat><Pl>}:{}

$PProGenPlSuff$ = {<Gen><Pl>}:{<SB>er} | \
                  {<Gen><Pl><Old>}:{} % cf. Duden-Grammatik (2016: § 363)

$PProGenPlSuff-er$ = {<Gen><Pl>}:{<SB>er} | \
                     {<Gen><Pl><NonSt>}:{<SB>er<del(e)|PRO><SB>er} % cf. Duden-Grammatik (2016: § 363)

$WProNomSgSuff$ = $PProNomSgSuff$

$WProAccSgSuff$ = $PProAccSgSuff$

$WProDatSgSuff$ = $PProDatSgSuff$

$WProGenSgSuff$ = {<Gen><Sg>}:{<SB>sen} | \
                  {<Gen><Sg><Old>}:{} % cf. Duden-Grammatik (2016: § 404)

$RProNomSgSuff$ = $WProNomSgSuff$

$RProAccSgSuff$ = $WProAccSgSuff$

$RProDatSgSuff$ = $WProDatSgSuff$

$RProGenSgSuff$ = {<Gen><Sg>}:{<SB>sen}

$IProNomSgSuff$ = $WProNomSgSuff$

$IProAccSgSuff$ = $WProAccSgSuff$

$IProDatSgSuff$ = $WProDatSgSuff$

$IProGenSgSuff$ = {<Gen><Sg>}:{<SB>sen}

% der, die, das (article)
$ArtDef$ = {<+ART><Def>}:{} $ArtDefSuff$

% der, die, das (relative pronoun)
$Rel$ = {<+REL>}:{} $RelSuff$

% der, die, das (demonstrative pronoun)
$DemDef$ = {<+DEM>}:{} $DemDefSuff$

% dieser, diese, dieses/dies
$Dem-dies$ = {<+DEM>}:{} $DemSuff-dies$

% solcher, solche, solches, solch
$Dem-solch$ = {<+DEM>}:{} $DemSuff-solch$

% alldem, alledem
$Dem-alldem$ = {<+DEM>}:{} $DemSuff-alldem$

% jener, jene, jenes
$Dem$ = {<+DEM>}:{} $DemSuff$

% derlei
$Dem0$ = {<+DEM>}:{} $DemSuff0$

% derjenige; derselbe
$ArtDef-der+DemMasc$ = {<+DEM>[<Attr><Subst>]<Masc>}:{} $ArtDef-der+DemMascSuff$

% denjenigen; denselben (masculine)
$ArtDef-den+DemMasc$ = {<+DEM>[<Attr><Subst>]<Masc>}:{} $ArtDef-den+DemMascSuff$

% demjenigen; demselben (masculine)
$ArtDef-dem+DemMasc$ = {<+DEM>[<Attr><Subst>]<Masc>}:{} $ArtDef-dem+DemMascSuff$

% desjenigen; desselben (masculine)
$ArtDef-des+DemMasc$ = {<+DEM>[<Attr><Subst>]<Masc>}:{} $ArtDef-des+DemMascSuff$

% dasjenige; dasselbe
$ArtDef-das+DemNeut$ = {<+DEM>[<Attr><Subst>]<Neut>}:{} $ArtDef-das+DemNeutSuff$

% demjenigen; demselben (neuter)
$ArtDef-dem+DemNeut$ = {<+DEM>[<Attr><Subst>]<Neut>}:{} $ArtDef-dem+DemNeutSuff$

% desjenigen; desselben (neuter)
$ArtDef-des+DemNeut$ = {<+DEM>[<Attr><Subst>]<Neut>}:{} $ArtDef-des+DemNeutSuff$

% diejenige; dieselbe
$ArtDef-die+DemFem$ = {<+DEM>[<Attr><Subst>]<Fem>}:{} $ArtDef-die+DemFemSuff$

% derjenigen; derselben (feminine)
$ArtDef-der+DemFem$ = {<+DEM>[<Attr><Subst>]<Fem>}:{} $ArtDef-der+DemFemSuff$

% diejenigen; dieselben
$ArtDef-die+DemNoGend$ = {<+DEM>[<Attr><Subst>]<NoGend>}:{} $ArtDef-die+DemNoGendSuff$

% denjenigen; denselben (plural)
$ArtDef-den+DemNoGend$ = {<+DEM>[<Attr><Subst>]<NoGend>}:{} $ArtDef-den+DemNoGendSuff$

% derjenigen; derselben (plural)
$ArtDef-der+DemNoGend$ = {<+DEM>[<Attr><Subst>]<NoGend>}:{} $ArtDef-der+DemNoGendSuff$

% welcher, welche, welches, welch (interrogative pronoun)
$W-welch$ = {<+WPRO>}:{} $WSuff-welch$

% welcher, welche, welches, welch (relative pronoun)
$Rel-welch$ = {<+REL>}:{} $RelSuff-welch$

% welcher, welche, welches (indefinite pronoun)
$Indef-welch$ = {<+INDEF>}:{} $IndefSuff-welch$

% irgendwelcher, irgendwelche, irgendwelches (indefinite pronoun)
$Indef-irgendwelch$ = {<+INDEF>}:{} $IndefSuff-irgendwelch$

% aller, alle, alles
$Indef-all$ = {<+INDEF>}:{} $IndefSuff-all$

% jeder, jede, jedes
$Indef-jed$ = {<+INDEF>}:{} $IndefSuff-jed$

% jeglicher, jegliche, jegliches
$Indef-jeglich$ = {<+INDEF>}:{} $IndefSuff-jeglich$

% sämtlicher, sämtliche, sämtliches
$Indef-saemtlich$ = {<+INDEF>}:{} $IndefSuff-saemtlich$

% beide, beides
$Indef-beid$ = {<+INDEF>}:{} $IndefSuff-beid$

% einiger, einige, einiges
$Indef-einig$ = {<+INDEF>}:{} $IndefSuff-einig$

% mancher, manche, manches, manch
$Indef-manch$ = {<+INDEF>}:{} $IndefSuff-manch$

% mehrere, mehreres
$Indef-mehrer$ = {<+INDEF>}:{} $IndefSuff-mehrer$

% genug
$Indef0$ = {<+INDEF>}:{} $IndefSuff0$

% ein, eine (article)
$ArtIndef$ = {<+ART><Indef>}:{} $ArtIndefSuff$

% 'n, 'ne (clitic article)
$ArtIndef-n$ = {<+ART><Indef>}:{} $ArtIndefAttrSuff$ {<NonSt>}:{} % cf. Duden-Grammatik (2016: § 448)

% einer, eine, eines (indefinite pronoun)
$Indef-ein$ = {<+INDEF>}:{} $IndefSuff-ein$

% irgendein, irgendeine
$Indef-irgendein$ = {<+INDEF>}:{} $ArtIndefSuff$

% kein, keine (article)
$ArtNeg$ = {<+ART><Neg>}:{} $ArtNegSuff$

% keiner, keine, keines (indefinite pronoun)
$Indef-kein$ = {<+INDEF>}:{} $IndefSuff-kein$

% mein, meine
$Poss$ = {<+POSS>}:{} $PossSuff$

% unser, unsere/unsre
$Poss-er$ = {<+POSS>}:{<del(e)|PRO>} $PossSuff$

% (die) meinigen/Meinigen
$Poss/Wk$ = {<+POSS>}:{} $PossSuff/Wk$

% unserige/unsrige
$Poss/Wk-er$ = {<+POSS>}:{<del(e)|PRO>} $PossSuff/Wk$

% etwas
$IProNeut$ = {<+INDEF><Neut>}:{} $IProSuff0$

% jemand
$IProMasc$ = {<+INDEF><Masc>}:{} $IProSuff$

% jedermann
$IPro-jedermann$ = {<+INDEF><Masc>}:{} $IProSuff-jedermann$

% jedefrau
$IPro-jedefrau$ = {<+INDEF><Fem>}:{} $IProSuff-jedefrau$

% jederfrau
$IPro-jederfrau$ = {<+INDEF><Fem>}:{} $IProSuff-jederfrau$

% man
$IPro-man$ = {<+INDEF><Masc>}:{} $IProSuff-man$

% frau
$IPro-frau$ = {<+INDEF><Fem>}:{} $IProSuff-man$

% unsereiner
$IPro-unsereiner$ = {<+INDEF><Masc>}:{} $IProSuff-unsereiner$

% unsereins
$IPro-unsereins$ = {<+INDEF><Masc>}:{} $IProSuff0$

% ich
$PPro1NomSg$ = {<+PPRO><Pers><1>}:{} $PProNomSgSuff$

% mich (irreflexive)
$PPro1AccSg$ = {<+PPRO><Pers><1>}:{} $PProAccSgSuff$

% mir (irreflexive)
$PPro1DatSg$ = {<+PPRO><Pers><1>}:{} $PProDatSgSuff$

% meiner, mein
$PPro1GenSg$ = {<+PPRO><Pers><1>}:{} $PProGenSgSuff$

% du
$PPro2NomSg$ = {<+PPRO><Pers><2>}:{} $PProNomSgSuff$

% dich (irreflexive)
$PPro2AccSg$ = {<+PPRO><Pers><2>}:{} $PProAccSgSuff$

% dir (irreflexive)
$PPro2DatSg$ = {<+PPRO><Pers><2>}:{} $PProDatSgSuff$

% deiner, dein
$PPro2GenSg$ = {<+PPRO><Pers><2>}:{} $PProGenSgSuff$

% sie (singular)
$PProFemNomSg$ = {<+PPRO><Pers><3><Fem>}:{} $PProNomSgSuff$

% sie (singular)
$PProFemAccSg$ = {<+PPRO><Pers><3><Fem>}:{} $PProAccSgSuff$

% ihr
$PProFemDatSg$ = {<+PPRO><Pers><3><Fem>}:{} $PProDatSgSuff$

% ihrer, ihr
$PProFemGenSg$ = {<+PPRO><Pers><3><Fem>}:{} $PProGenSgSuff$

% er
$PProMascNomSg$ = {<+PPRO><Pers><3><Masc>}:{} $PProNomSgSuff$

% ihn
$PProMascAccSg$ = {<+PPRO><Pers><3><Masc>}:{} $PProAccSgSuff$

% ihm
$PProMascDatSg$ = {<+PPRO><Pers><3><Masc>}:{} $PProDatSgSuff$

% seiner, sein
$PProMascGenSg$ = {<+PPRO><Pers><3><Masc>}:{} $PProGenSgSuff$

% es
$PProNeutNomSg$ = {<+PPRO><Pers><3><Neut>}:{} $PProNomSgSuff$

% 's (clitic pronoun)
$PProNeutNomSg-s$ = $PProNeutNomSg$ {<NonSt>}:{}

% es
$PProNeutAccSg$ = {<+PPRO><Pers><3><Neut>}:{} $PProAccSgSuff$

% 's (clitic pronoun)
$PProNeutAccSg-s$ = $PProNeutAccSg$ {<NonSt>}:{}

% ihm
$PProNeutDatSg$ = {<+PPRO><Pers><3><Neut>}:{} $PProDatSgSuff$

% seiner
$PProNeutGenSg$ = {<+PPRO><Pers><3><Neut>}:{} $PProGenSgSuff$

% wir
$PPro1NomPl$ = {<+PPRO><Pers><1>}:{} $PProNomPlSuff$

% uns (irreflexive)
$PPro1AccPl$ = {<+PPRO><Pers><1>}:{} $PProAccPlSuff$

% uns (irreflexive)
$PPro1DatPl$ = {<+PPRO><Pers><1>}:{} $PProDatPlSuff$

% unser, unserer/unsrer
$PPro1GenPl$ = {<+PPRO><Pers><1>}:{} $PProGenPlSuff-er$

% ihr
$PPro2NomPl$ = {<+PPRO><Pers><2>}:{} $PProNomPlSuff$

% euch (irreflexive)
$PPro2AccPl$ = {<+PPRO><Pers><2>}:{} $PProAccPlSuff$

% euch (irreflexive)
$PPro2DatPl$ = {<+PPRO><Pers><2>}:{} $PProDatPlSuff$

% euer, eurer
$PPro2GenPl$ = {<+PPRO><Pers><2>}:{} $PProGenPlSuff-er$

% sie (plural)
$PProNoGendNomPl$ = {<+PPRO><Pers><3><NoGend>}:{} $PProNomPlSuff$

% sie (plural)
$PProNoGendAccPl$ = {<+PPRO><Pers><3><NoGend>}:{} $PProAccPlSuff$

% ihr
$PProNoGendDatPl$ = {<+PPRO><Pers><3><NoGend>}:{} $PProDatPlSuff$

% ihrer, ihr
$PProNoGendGenPl$ = {<+PPRO><Pers><3><NoGend>}:{} $PProGenPlSuff$

% mich (reflexive)
$PRefl1AccSg$ = {<+PPRO><Refl><1>}:{} $PProAccSgSuff$

% mir (reflexive)
$PRefl1DatSg$ = {<+PPRO><Refl><1>}:{} $PProDatSgSuff$

% dich (reflexive)
$PRefl2AccSg$ = {<+PPRO><Refl><2>}:{} $PProAccSgSuff$

% dir (reflexive)
$PRefl2DatSg$ = {<+PPRO><Refl><2>}:{} $PProDatSgSuff$

% uns (reflexive)
$PRefl1Pl$ = {<+PPRO><Refl><1>}:{} $PProAccPlSuff$ | \
             {<+PPRO><Refl><1>}:{} $PProDatPlSuff$

% euch (reflexive)
$PRefl2Pl$ = {<+PPRO><Refl><2>}:{} $PProAccPlSuff$ | \
             {<+PPRO><Refl><2>}:{} $PProDatPlSuff$

% sich
$PRefl3$ = {<+PPRO><Refl><3>}:{} $PProAccSgSuff$ | \
           {<+PPRO><Refl><3>}:{} $PProDatSgSuff$ | \
           {<+PPRO><Refl><3>}:{} $PProAccPlSuff$ | \
           {<+PPRO><Refl><3>}:{} $PProDatPlSuff$

% einander
$PRecPl$ = {<+PPRO><Rec><1>}:{} $PProAccPlSuff$ | \
           {<+PPRO><Rec><1>}:{} $PProDatPlSuff$ | \
           {<+PPRO><Rec><2>}:{} $PProDatPlSuff$ | \
           {<+PPRO><Rec><2>}:{} $PProAccPlSuff$ | \
           {<+PPRO><Rec><3>}:{} $PProAccPlSuff$ | \
           {<+PPRO><Rec><3>}:{} $PProDatPlSuff$ % cf. Duden-Grammatik (2016: § 366)

% wer (interrogative pronoun)
$WProMascNomSg$ = {<+WPRO><Masc>}:{} $WProNomSgSuff$

% wen (interrogative pronoun)
$WProMascAccSg$ = {<+WPRO><Masc>}:{} $WProAccSgSuff$

% wem (interrogative pronoun)
$WProMascDatSg$ = {<+WPRO><Masc>}:{} $WProDatSgSuff$

% wessen, wes (interrogative pronoun)
$WProMascGenSg$ = {<+WPRO><Masc>}:{} $WProGenSgSuff$

% was (interrogative pronoun)
$WProNeutNomSg$ = {<+WPRO><Neut>}:{} $WProNomSgSuff$

% was (interrogative pronoun)
$WProNeutAccSg$ = {<+WPRO><Neut>}:{} $WProAccSgSuff$

% was (interrogative pronoun)
$WProNeutDatSg$ = {<+WPRO><Neut>}:{} $WProDatSgSuff$ {<NonSt>}:{} % cf. Duden-Grammatik (2016: § 404)

% wessen, wes (interrogative pronoun)
$WProNeutGenSg$ = {<+WPRO><Neut>}:{} $WProGenSgSuff$

% wer (relative pronoun)
$RProMascNomSg$ = {<+REL><Masc>}:{} $RProNomSgSuff$

% wen (relative pronoun)
$RProMascAccSg$ = {<+REL><Masc>}:{} $RProAccSgSuff$

% wem (relative pronoun)
$RProMascDatSg$ = {<+REL><Masc>}:{} $RProDatSgSuff$

% wessen (relative pronoun)
$RProMascGenSg$ = {<+REL><Masc>}:{} $RProGenSgSuff$

% was (relative pronoun)
$RProNeutNomSg$ = {<+REL><Neut>}:{} $RProNomSgSuff$

% was (relative pronoun)
$RProNeutAccSg$ = {<+REL><Neut>}:{} $RProAccSgSuff$

% was (relative pronoun)
$RProNeutDatSg$ = {<+REL><Neut>}:{} $RProDatSgSuff$ {<NonSt>}:{}

% wessen (relative pronoun)
$RProNeutGenSg$ = {<+REL><Neut>}:{} $RProGenSgSuff$

% wer (indefinite pronoun)
$IProMascNomSg$ = {<+INDEF><Masc>}:{} $IProNomSgSuff$

% wen (indefinite pronoun)
$IProMascAccSg$ = {<+INDEF><Masc>}:{} $IProAccSgSuff$

% wem (indefinite pronoun)
$IProMascDatSg$ = {<+INDEF><Masc>}:{} $IProDatSgSuff$

% wessen (indefinite pronoun)
$IProMascGenSg$ = {<+INDEF><Masc>}:{} $IProGenSgSuff$

% was (indefinite pronoun)
$IProNeutNomSg$ = {<+INDEF><Neut>}:{} $IProNomSgSuff$

% was (indefinite pronoun)
$IProNeutAccSg$ = {<+INDEF><Neut>}:{} $IProAccSgSuff$

% was (indefinite pronoun)
$IProNeutDatSg$ = {<+INDEF><Neut>}:{} $IProDatSgSuff$ {<NonSt>}:{}

% wessen (indefinite pronoun)
$IProNeutGenSg$ = {<+INDEF><Neut>}:{} $IProGenSgSuff$


% numerals

$CardSuff0$ = {[<Attr><Subst>]<Invar>}:{}

$CardSuff-ein/St$ = $ArtIndefSuff$

$CardSuff-ein/Wk$ = {[<Attr><Subst>]<Masc><Nom><Sg><Wk>}:{<SB>e}  | \
                    {[<Attr><Subst>]<Masc><Acc><Sg><Wk>}:{<SB>en} | \
                    {[<Attr><Subst>]<Masc><Dat><Sg><Wk>}:{<SB>en} | \
                    {[<Attr><Subst>]<Masc><Gen><Sg><Wk>}:{<SB>en} | \
                    {[<Attr><Subst>]<Neut><Nom><Sg><Wk>}:{<SB>e}  | \
                    {[<Attr><Subst>]<Neut><Acc><Sg><Wk>}:{<SB>e}  | \
                    {[<Attr><Subst>]<Neut><Dat><Sg><Wk>}:{<SB>en} | \
                    {[<Attr><Subst>]<Neut><Gen><Sg><Wk>}:{<SB>en} | \
                    {[<Attr><Subst>]<Fem><Nom><Sg><Wk>}:{<SB>e}   | \
                    {[<Attr><Subst>]<Fem><Acc><Sg><Wk>}:{<SB>e}   | \
                    {[<Attr><Subst>]<Fem><Dat><Sg><Wk>}:{<SB>en}  | \
                    {[<Attr><Subst>]<Fem><Gen><Sg><Wk>}:{<SB>en}

$CardSuff-ein$ = $CardSuff-ein/St$ | \
                 $CardSuff-ein/Wk$

$CardSuff-kein$ = $ArtNegSuff$

$CardSuff-zwei$ = $CardSuff0$                                     | \
                  {<Subst><NoGend><Nom><Pl><St><NonSt>}:{<SB>e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Acc><Pl><St><NonSt>}:{<SB>e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><St>}:{<SB>en}         | \ % cf. Duden-Grammatik (2016: § 511)
                  {[<Attr><Subst>]<NoGend><Gen><Pl><St>}:{<SB>er} | \   % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Nom><Pl><Wk><NonSt>}:{<SB>e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Acc><Pl><Wk><NonSt>}:{<SB>e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><Wk>}:{<SB>en}             % cf. Duden-Grammatik (2016: § 511)

$CardSuff-vier$ = $CardSuff0$                                   | \
                  {<Subst><NoGend><Nom><Pl><St><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Acc><Pl><St><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><St>}:{<SB>en}       | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Nom><Pl><Wk><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Acc><Pl><Wk><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><NoGend><Dat><Pl><Wk>}:{<SB>en}           % cf. Duden-Grammatik (2016: § 511)

$CardSuff-sieben$ = $CardSuff0$                                   | \
                    {<Subst><NoGend><Nom><Pl><St><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                    {<Subst><NoGend><Acc><Pl><St><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                    {<Subst><NoGend><Nom><Pl><Wk><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                    {<Subst><NoGend><Acc><Pl><Wk><NonSt>}:{<SB>e}     % cf. Duden-Grammatik (2016: § 511)

% ein, eine (cardinal)
$Card-ein$ = {<+CARD>}:{} $CardSuff-ein$

% kein, keine (cardinal)
$Card-kein$ = {<+CARD>}:{} $CardSuff-kein$

% zwei, zweien, zweier; drei, dreien, dreier
$Card-zwei$ = {<+CARD>}:{} $CardSuff-zwei$

% vier, vieren; zwölf, zwölfen
$Card-vier$ = {<+CARD>}:{} $CardSuff-vier$

% sieben
$Card-sieben$ = {<+CARD>}:{} $CardSuff-sieben$

% null; zwo; dreizehn; zwanzig; hundert
$Card0$ = <+CARD>:<> $CardSuff0$

% erst-
$Ord$ = {<+ORD>}:{} $AdjInflSuff$

% eineinhalb; anderthalb; drittel
$Frac0$ = <+FRAC>:<> $CardSuff0$

% 1
$DigCard$ = {<+CARD><Invar>}:{}

% 1.
$DigOrd$ = {<+ORD><Invar>}:{}

% 1,5
$DigFrac$ = {<+FRAC><Invar>}:{}

% I
$Roman$ = {<+CARD><Invar>}:{}


% adverbs

% oft; gern; sehr
$Adv$ = {<+ADV>}:{}

% mehr
$AdvComp0$ = {<+ADV><Comp>}:{}

% öfter; lieber
$AdvComp$ = {<+ADV><Comp>}:{<SB>er}

% öftesten; liebsten; meisten
$AdvSup$ = {<+ADV><Sup>}:{<SB>sten}


% verbs

% sei; hab(e); werde; tu
$VAImpSg$ = {<+V><Imp><Sg>}:{<SB><rm|Imp>}

% seid; habt; werdet; tut
$VAImpPl$ = {<+V><Imp><Pl>}:{<SB><rm|Imp>}

% bin; habe; werde; tue
$VAPres1SgInd$ = {<+V><1><Sg><Pres><Ind>}:{}

% bist; hast; wirst; tust
$VAPres2SgInd$ = {<+V><2><Sg><Pres><Ind>}:{}

% ist; hat; wird; tut
$VAPres3SgInd$ = {<+V><3><Sg><Pres><Ind>}:{}

% sind; haben; werden; tun
$VAPres13PlInd$ = {<+V><1><Pl><Pres><Ind>}:{} | \
                  {<+V><3><Pl><Pres><Ind>}:{}

% seid; habt; werdet; tut
$VAPres2PlInd$ = {<+V><2><Pl><Pres><Ind>}:{}

% seist, seiest; habest; werdest; tuest
$VAPres2SgSubj$ = {<+V><2><Sg><Pres><Subj>}:{<SB>st}

$VAPresSubjSg$ = {<+V><1><Sg><Pres><Subj>}:{}       | \
                 {<+V><2><Sg><Pres><Subj>}:{<SB>st} | \
                 {<+V><3><Sg><Pres><Subj>}:{}

$VAPresSubjPl$ = {<+V><1><Pl><Pres><Subj>}:{<SB>n} | \
                 {<+V><2><Pl><Pres><Subj>}:{<SB>t} | \
                 {<+V><3><Pl><Pres><Subj>}:{<SB>n}

% ward, wardst
$VAPastIndSg$ = {<+V><1><Sg><Past><Ind>}:{}       | \
                {<+V><2><Sg><Past><Ind>}:{<SB>st} | \
                {<+V><3><Sg><Past><Ind>}:{}

% wurden, wurdet
$VAPastIndPl$ = {<+V><1><Pl><Past><Ind>}:{<SB>en}        | \
                {<+V><2><Pl><Past><Ind>}:{<SB><ins(e)>t} | \
                {<+V><3><Pl><Past><Ind>}:{<SB>en}

$VAPastSubj2$ = {<+V><2><Sg><Past><Subj>}:{<SB>st} | \
                {<+V><2><Pl><Past><Subj>}:{<SB>t}

$haben$ = {<haben>}:{}

$sein$ = {<sein>}:{}

$VPPres$ = {<+V><PPres>}:{} | \
           {<+V><PPres><zu>}:{<ins(zu)>}

$VPPast$ = {<+V><PPast>}:{<ins(ge)>}

$VPPast+haben$ = $VPPast$ $haben$

$VPPast+sein$ = $VPPast$ $sein$

$VPP-en$ = {}:{<SB>en} $VPPast$

$VPP-t$ =  {}:{<SB><ins(e)>t} $VPPast$

$VInf$ = {<+V><Inf>}:{} | \
         {<+V><Inf><zu>}:{<ins(zu)>}

$VInfStem$ = {}:{<SB>en}  $VInf$ | \
             {}:{<SB>end} $VPPres$

% sein, seiend; tun, tuend
$VInfStem-n$ = {}:{<SB>n}   $VInf$ | \
               {}:{<SB>end} $VPPres$

$VInf-en$ = $VInfStem$

$VInf-n$ = $VInfStem-n$

% komm(e); schau(e); arbeit(e); widme
$VImpSg$ = {<+V><Imp><Sg>}:{<SB><ins(e)><rm|Imp>} | \
           {<+V><Imp><Sg>}:{<SB>e<rm|Imp>}

% flicht
$VImpSg0$ = {<+V><Imp><Sg>}:{<SB><rm|Imp>}

% kommt; schaut; arbeitet
$VImpPl$ = {<+V><Imp><Pl>}:{<SB><ins(e)>t<rm|Imp>}

% will; bedarf
$VPres1Irreg$ = {<+V><1><Sg><Pres><Ind>}:{}

% liebe; rate; sammle
$VPres1Reg$ = {<+V><1><Sg><Pres><Ind>}:{<SB>e}

% hilfst; rätst
$VPres2Irreg$ = {<+V><2><Sg><Pres><Ind>}:{<SB>st}

% liebst; bietest; sammelst
$VPres2Reg$ = {<+V><2><Sg><Pres><Ind>}:{<SB><ins(e)>st}

% rät; will
$VPres3Irreg$ = {<+V><3><Sg><Pres><Ind>}:{}

% liebt; hilft; sammelt
$VPres3Reg$ = {<+V><3><Sg><Pres><Ind>}:{<SB><ins(e)>t}

% lieben; wollen; sammeln
% liebt; bietet; sammelt
$VPresPlInd$ = {<+V><1><Pl><Pres><Ind>}:{<SB>en}        | \
               {<+V><2><Pl><Pres><Ind>}:{<SB><ins(e)>t} | \
               {<+V><3><Pl><Pres><Ind>}:{<SB>en}

% liebe; wolle; sammle
% liebest; wollest; sammelst
% lieben; wollen; sammeln
% liebet; wollet; sammelt
$VPresSubj$ = {<+V><1><Sg><Pres><Subj>}:{<SB>e}   | \
              {<+V><2><Sg><Pres><Subj>}:{<SB>est} | \
              {<+V><3><Sg><Pres><Subj>}:{<SB>e}   | \
              {<+V><1><Pl><Pres><Subj>}:{<SB>en}  | \
              {<+V><2><Pl><Pres><Subj>}:{<SB>et}  | \
              {<+V><3><Pl><Pres><Subj>}:{<SB>en}

% brachte
$VPastIndReg$ = {<+V><1><Sg><Past><Ind>}:{<SB><ins(e)>t<SB>e}   | \
                {<+V><2><Sg><Past><Ind>}:{<SB><ins(e)>t<SB>est} | \
                {<+V><3><Sg><Past><Ind>}:{<SB><ins(e)>t<SB>e}   | \
                {<+V><1><Pl><Past><Ind>}:{<SB><ins(e)>t<SB>en}  | \
                {<+V><2><Pl><Past><Ind>}:{<SB><ins(e)>t<SB>et}  | \
                {<+V><3><Pl><Past><Ind>}:{<SB><ins(e)>t<SB>en}

% wurde
$VPastIndIrreg$ = {<+V><1><Sg><Past><Ind>}:{<SB>e}   | \
                  {<+V><2><Sg><Past><Ind>}:{<SB>est} | \
                  {<+V><3><Sg><Past><Ind>}:{<SB>e}   | \
                  {<+V><1><Pl><Past><Ind>}:{<SB>en}  | \
                  {<+V><2><Pl><Past><Ind>}:{<SB>et}  | \
                  {<+V><3><Pl><Past><Ind>}:{<SB>en}

% fuhr; ritt; fand
% fuhrst; ritt(e)st; fand(e)st
$VPastIndStr$ = {<+V><1><Sg><Past><Ind>}:{}               | \
                {<+V><2><Sg><Past><Ind>}:{<SB><ins(e)>st} | \
                {<+V><2><Sg><Past><Ind>}:{<SB>st}         | \ % cf. Duden-Grammatik (2016: § 642)
                {<+V><3><Sg><Past><Ind>}:{}               | \
                {<+V><1><Pl><Past><Ind>}:{<SB>en}         | \
                {<+V><2><Pl><Past><Ind>}:{<SB><ins(e)>t}  | \
                {<+V><3><Pl><Past><Ind>}:{<SB>en}

% brächte
$VPastSubjReg$ = {<+V><1><Sg><Past><Subj>}:{<SB><ins(e)>t<SB>e}   | \
                 {<+V><2><Sg><Past><Subj>}:{<SB><ins(e)>t<SB>est} | \
                 {<+V><3><Sg><Past><Subj>}:{<SB><ins(e)>t<SB>e}   | \
                 {<+V><1><Pl><Past><Subj>}:{<SB><ins(e)>t<SB>en}  | \
                 {<+V><2><Pl><Past><Subj>}:{<SB><ins(e)>t<SB>et}  | \
                 {<+V><3><Pl><Past><Subj>}:{<SB><ins(e)>t<SB>en}

% führe; ritte; fände
$VPastSubjStr$ = {<+V><1><Sg><Past><Subj>}:{<SB>e}   | \
                 {<+V><2><Sg><Past><Subj>}:{<SB>est} | \
                 {<+V><3><Sg><Past><Subj>}:{<SB>e}   | \
                 {<+V><1><Pl><Past><Subj>}:{<SB>en}  | \
                 {<+V><2><Pl><Past><Subj>}:{<SB>et}  | \
                 {<+V><3><Pl><Past><Subj>}:{<SB>en}

$VInflPres2$ = $VPres2Irreg$ | \
               $VPres3Reg$

$VInflPres2t$ = $VPres2Irreg$ | \
                $VPres3Irreg$

$VInflPres1$ = $VPres1Reg$  | \
               $VPresPlInd$ | \
               $VPresSubj$  | \
               $VImpPl$

$VInflPresReg$ = $VInflPres1$ | \
                 $VPres2Reg$  | \
                 $VPres3Reg$  | \
                 $VImpSg$

$VInflReg$ =  $VInflPresReg$ | \
              $VPastIndReg$  | \
              $VPastSubjReg$

$VModInflSg$ = $VPres1Irreg$ | \
               $VPres2Reg$   | \
               $VPres3Irreg$

$VModInflPl$ = $VPresPlInd$ | \
               $VPresSubj$

$VVPres$ = $VInflPresReg$ | \
           $VInfStem$

$VVPres1$ = $VInflPres1$ | \
            $VInfStem$

$VVPres1_Imp$ = $VImpSg$ | \
                $VVPres1$

$VVPres2$ = $VInflPres2$

$VVPres2t$ = $VInflPres2t$

$VVPres2_Imp$ = $VImpSg$ | \
                $VVPres2$

$VVPres2_Imp0$ = $VImpSg0$ | \
                 $VVPres2$

$VVPres2t_Imp0$ = $VImpSg0$ | \
                  $VVPres2t$

$VVPastIndReg$ = $VPastIndReg$

$VVPastIndStr$ = $VPastIndStr$

$VVPastSubjReg$ = $VPastSubjReg$

$VVPastSubjStr$ = $VPastSubjStr$

$VVPastSubjOld$ = $VVPastSubjStr$ {<Old>}:{}

$VVPastStr$ = $VVPastIndStr$ | \
              $VVPastSubjStr$

% lieben; spielen
$VVReg$ = $VInflReg$ | \
          $VPP-t$    | \
          $VInfStem$

$VVReg+haben$ = $VInflReg$      | \
                $VPP-t$ $haben$ | \
                $VInfStem$

$VVReg+sein$ = $VInflReg$     | \
               $VPP-t$ $sein$ | \
               $VInfStem$

% angeln; rudern (cf. $SchwaTrigger$ in markers.fst)
$VVReg-el-er$ = $VVReg$

$VVReg-el-er+haben$ = $VVReg+haben$

$VVReg-el-er+sein$ = $VVReg+sein$

$VMPastSubj$ = $VPastSubjReg$

$VMPresSg$ = $VModInflSg$

$VMPresPl$ = $VModInflPl$ | \
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

% unter
$Prep$ = {<+PREP>}:{}

% unterm
$Prep+Art-m$ = {<+PREPART><Masc><Dat><Sg>}:{} | \
               {<+PREPART><Neut><Dat><Sg>}:{}

% untern
$Prep+Art-n$ = {<+PREPART><Masc><Acc><Sg>}:{}

% unters
$Prep+Art-s$ = {<+PREPART><Neut><Acc><Sg>}:{}

% zur
$Prep+Art-r$ = {<+PREPART><Fem><Dat><Sg>}:{}

% zufolge, willen
$Postp$ = {<+POSTP>}:{}


% other words

$Intj$ = {<+INTJ>}:{}

$ConjInf$ = {<+CONJ><Inf>}:{}

$ConjCoord$ = {<+CONJ><Coord>}:{}

$ConjSub$ = {<+CONJ><Sub>}:{}

$ConjCompar$ = {<+CONJ><Compar>}:{}

$PIndInvar$ = {<+INDEF><Invar>}:{}

$ProAdv$ = {<+PROADV>}:{}

$PtclAdj$ = {<+PTCL><Adj>}:{}

$PtclNeg$ = {<+PTCL><Neg>}:{}

$Ptcl-zu$ = {<+PTCL><zu>}:{}

$WAdv$ = {<+WADV>}:{}

$VPart$ = {<+VPART>}:{}


% abbreviations

% Kfm. (= Kaufmann)
$AbbrNMasc$ = {<+NN><Masc><Invar>}:{}

% Gr. (= Gros)
$AbbrNNeut$ = {<+NN><Neut><Invar>}:{}

% Kffr. (= Kauffrau)
$AbbrNFem$ = {<+NN><Fem><Invar>}:{}

% Gebr. (= Gebrüder)
$AbbrNNoGend$ = {<+NN><NoGend><Invar>}:{}

% f. (= folgende)
$AbbrAdj$ = {<+ADJ><Pos><Invar>}:{}

% Ew. (= Euer)
$AbbrPoss$ = {<+POSS><Attr><Invar>}:{}

% vgl. (= vergleiche)
$AbbrVImp$ = {<+V><Imp><Invar>}:{}


% inflection transducer

$INFL$ = <>:<AbbrAdj>               $AbbrAdj$              | \
         <>:<AbbrNFem>              $AbbrNFem$             | \
         <>:<AbbrNMasc>             $AbbrNMasc$            | \
         <>:<AbbrNNeut>             $AbbrNNeut$            | \
         <>:<AbbrNNoGend>           $AbbrNNoGend$          | \
         <>:<AbbrPoss>              $AbbrPoss$             | \
         <>:<AbbrVImp>              $AbbrVImp$             | \
         <>:<Adj-el_$>              $Adj-el_\$$            | \
         <>:<Adj-el_0>              $Adj-el_0$             | \
         <>:<Adj-en_0>              $Adj-en_0$             | \
         <>:<Adj-er_0>              $Adj-er_0$             | \
         <>:<Adj-Lang>              $Adj-Lang$             | \
         <>:<Adj_$>                 $Adj_\$$               | \
         <>:<Adj_$e>                $Adj_\$e$              | \
         <>:<Adj_0>                 $Adj_0$                | \
         <>:<Adj_e>                 $Adj_e$                | \
         <>:<AdjComp>               $AdjComp$              | \
         <>:<AdjComp0-mehr>         $AdjComp0-mehr$        | \
         <>:<AdjPos>                $AdjPos$               | \
         <>:<AdjPos0>               $AdjPos0$              | \
         <>:<AdjPos0-viel>          $AdjPos0-viel$         | \
         <>:<AdjPos0Attr>           $AdjPos0Attr$          | \
         <>:<AdjPos0AttrSubst>      $AdjPos0AttrSubst$     | \
         <>:<AdjPosAttr>            $AdjPosAttr$           | \
         <>:<AdjPosAttr-er>         $AdjPosAttr-er$        | \
         <>:<AdjPosPred>            $AdjPosPred$           | \
         <>:<AdjSup>                $AdjSup$               | \
         <>:<AdjSup-aller>          $AdjSup-aller$         | \
         <>:<AdjSupAttr>            $AdjSupAttr$           | \
         <>:<Adv>                   $Adv$                  | \
         <>:<AdvComp>               $AdvComp$              | \
         <>:<AdvComp0>              $AdvComp0$             | \
         <>:<AdvSup>                $AdvSup$               | \
         <>:<ArtDef>                $ArtDef$               | \
         <>:<ArtDef-das+DemNeut>    $ArtDef-das+DemNeut$   | \
         <>:<ArtDef-dem+DemMasc>    $ArtDef-dem+DemMasc$   | \
         <>:<ArtDef-dem+DemNeut>    $ArtDef-dem+DemNeut$   | \
         <>:<ArtDef-den+DemMasc>    $ArtDef-den+DemMasc$   | \
         <>:<ArtDef-den+DemNoGend>  $ArtDef-den+DemNoGend$ | \
         <>:<ArtDef-der+DemFem>     $ArtDef-der+DemFem$    | \
         <>:<ArtDef-der+DemMasc>    $ArtDef-der+DemMasc$   | \
         <>:<ArtDef-der+DemNoGend>  $ArtDef-der+DemNoGend$ | \
         <>:<ArtDef-des+DemMasc>    $ArtDef-des+DemMasc$   | \
         <>:<ArtDef-des+DemNeut>    $ArtDef-des+DemNeut$   | \
         <>:<ArtDef-die+DemFem>     $ArtDef-die+DemFem$    | \
         <>:<ArtDef-die+DemNoGend>  $ArtDef-die+DemNoGend$ | \
         <>:<ArtIndef>              $ArtIndef$             | \
         <>:<ArtIndef-n>            $ArtIndef-n$           | \
         <>:<ArtNeg>                $ArtNeg$               | \
         <>:<Card0>                 $Card0$                | \
         <>:<Card-ein>              $Card-ein$             | \
         <>:<Card-kein>             $Card-kein$            | \
         <>:<Card-sieben>           $Card-sieben$          | \
         <>:<Card-vier>             $Card-vier$            | \
         <>:<Card-zwei>             $Card-zwei$            | \
         <>:<ConjCompar>            $ConjCompar$           | \
         <>:<ConjCoord>             $ConjCoord$            | \
         <>:<ConjInf>               $ConjInf$              | \
         <>:<ConjSub>               $ConjSub$              | \
         <>:<Dem>                   $Dem$                  | \
         <>:<Dem0>                  $Dem0$                 | \
         <>:<Dem-alldem>            $Dem-alldem$           | \
         <>:<Dem-dies>              $Dem-dies$             | \
         <>:<Dem-solch>             $Dem-solch$            | \
         <>:<DemDef>                $DemDef$               | \
         <>:<DigCard>               $DigCard$              | \
         <>:<DigFrac>               $DigFrac$              | \
         <>:<DigOrd>                $DigOrd$               | \
         <>:<Frac0>                 $Frac0$                | \
         <>:<Indef0>                $Indef0$               | \
         <>:<Indef-all>             $Indef-all$            | \
         <>:<Indef-beid>            $Indef-beid$           | \
         <>:<Indef-ein>             $Indef-ein$            | \
         <>:<Indef-einig>           $Indef-einig$          | \
         <>:<Indef-irgendein>       $Indef-irgendein$      | \
         <>:<Indef-irgendwelch>     $Indef-irgendwelch$    | \
         <>:<Indef-jed>             $Indef-jed$            | \
         <>:<Indef-jeglich>         $Indef-jeglich$        | \
         <>:<Indef-kein>            $Indef-kein$           | \
         <>:<Indef-manch>           $Indef-manch$          | \
         <>:<Indef-mehrer>          $Indef-mehrer$         | \
         <>:<Indef-saemtlich>       $Indef-saemtlich$      | \
         <>:<Indef-welch>           $Indef-welch$          | \
         <>:<IPro-frau>             $IPro-frau$            | \
         <>:<IPro-jedefrau>         $IPro-jedefrau$        | \
         <>:<IPro-jederfrau>        $IPro-jederfrau$       | \
         <>:<IPro-jedermann>        $IPro-jedermann$       | \
         <>:<IPro-man>              $IPro-man$             | \
         <>:<IPro-unsereiner>       $IPro-unsereiner$      | \
         <>:<IPro-unsereins>        $IPro-unsereins$       | \
         <>:<IProMasc>              $IProMasc$             | \
         <>:<IProMascAccSg>         $IProMascAccSg$        | \
         <>:<IProMascDatSg>         $IProMascDatSg$        | \
         <>:<IProMascGenSg>         $IProMascGenSg$        | \
         <>:<IProMascNomSg>         $IProMascNomSg$        | \
         <>:<IProNeut>              $IProNeut$             | \
         <>:<IProNeutAccSg>         $IProNeutAccSg$        | \
         <>:<IProNeutDatSg>         $IProNeutDatSg$        | \
         <>:<IProNeutGenSg>         $IProNeutGenSg$        | \
         <>:<IProNeutNomSg>         $IProNeutNomSg$        | \
         <>:<Intj>                  $Intj$                 | \
         <>:<Name-Fam_0>            $Name-Fam_0$           | \
         <>:<Name-Fam_s>            $Name-Fam_s$           | \
         <>:<NameFem_0>             $NameFem_0$            | \
         <>:<NameFem_apos>          $NameFem_apos$         | \
         <>:<NameFem_s>             $NameFem_s$            | \
         <>:<NameMasc_0>            $NameMasc_0$           | \
         <>:<NameMasc_apos>         $NameMasc_apos$        | \
         <>:<NameMasc_es>           $NameMasc_es$          | \
         <>:<NameMasc_s>            $NameMasc_s$           | \
         <>:<NameNeut_0>            $NameNeut_0$           | \
         <>:<NameNeut_apos>         $NameNeut_apos$        | \
         <>:<NameNeut_es>           $NameNeut_es$          | \
         <>:<NameNeut_s>            $NameNeut_s$           | \
         <>:<NameNoGend/Pl_0>       $NameNoGend/Pl_0$      | \
         <>:<NameNoGend/Pl_x>       $NameNoGend/Pl_x$      | \
         <>:<NFem-Adj>              $NFem-Adj$             | \
         <>:<NFem-in>               $NFem-in$              | \
         <>:<NFem/Pl_x>             $NFem/Pl_x$            | \
         <>:<NFem/Sg_0>             $NFem/Sg_0$            | \
         <>:<NFem_0_$>              $NFem_0_\$$            | \
         <>:<NFem_0_$e>             $NFem_0_\$e$           | \
         <>:<NFem_0_$en>            $NFem_0_\$en$          | \
         <>:<NFem_0_0>              $NFem_0_0$             | \
         <>:<NFem_0_a/en>           $NFem_0_a/en$          | \
         <>:<NFem_0_e>              $NFem_0_e$             | \
         <>:<NFem_0_e~ss>           $NFem_0_e~ss$          | \
         <>:<NFem_0_anx/angen>      $NFem_0_anx/angen$     | \
         <>:<NFem_0_e/i>            $NFem_0_e/i$           | \
         <>:<NFem_0_en>             $NFem_0_en$            | \
         <>:<NFem_0_es>             $NFem_0_es$            | \
         <>:<NFem_0_ex/eges>        $NFem_0_ex/eges$       | \
         <>:<NFem_0_is/en>          $NFem_0_is/en$         | \
         <>:<NFem_0_is/iden>        $NFem_0_is/iden$       | \
         <>:<NFem_0_ix/izen>        $NFem_0_ix/izen$       | \
         <>:<NFem_0_ix/izes>        $NFem_0_ix/izes$       | \
         <>:<NFem_0_n>              $NFem_0_n$             | \
         <>:<NFem_0_s>              $NFem_0_s$             | \
         <>:<NFem_0_x>              $NFem_0_x$             | \
         <>:<NMasc-Adj>             $NMasc-Adj$            | \
         <>:<NMasc/Pl_x>            $NMasc/Pl_x$           | \
         <>:<NMasc/Sg_0>            $NMasc/Sg_0$           | \
         <>:<NMasc/Sg_es>           $NMasc/Sg_es$          | \
         <>:<NMasc/Sg_ns>           $NMasc/Sg_ns$          | \
         <>:<NMasc/Sg_s>            $NMasc/Sg_s$           | \
         <>:<NMasc_0_$e>            $NMasc_0_\$e$          | \
         <>:<NMasc_0_0>             $NMasc_0_0$            | \
         <>:<NMasc_0_as/anten>      $NMasc_0_as/anten$     | \
         <>:<NMasc_0_e>             $NMasc_0_e$            | \
         <>:<NMasc_0_e~ss>          $NMasc_0_e~ss$         | \
         <>:<NMasc_0_e/i>           $NMasc_0_e/i$          | \
         <>:<NMasc_0_en>            $NMasc_0_en$           | \
         <>:<NMasc_0_es>            $NMasc_0_es$           | \
         <>:<NMasc_0_ex/izes>       $NMasc_0_ex/izes$      | \
         <>:<NMasc_0_nen>           $NMasc_0_nen$          | \
         <>:<NMasc_0_o/en>          $NMasc_0_o/en$         | \
         <>:<NMasc_0_o/i>           $NMasc_0_o/i$          | \
         <>:<NMasc_0_os/oden>       $NMasc_0_os/oden$      | \
         <>:<NMasc_0_os/oen>        $NMasc_0_os/oen$       | \
         <>:<NMasc_0_os/oi>         $NMasc_0_os/oi$        | \
         <>:<NMasc_0_s>             $NMasc_0_s$            | \
         <>:<NMasc_0_us/e>          $NMasc_0_us/e$         | \
         <>:<NMasc_0_us/een>        $NMasc_0_us/een$       | \
         <>:<NMasc_0_us/en>         $NMasc_0_us/en$        | \
         <>:<NMasc_0_us/i>          $NMasc_0_us/i$         | \
         <>:<NMasc_0_us/ier>        $NMasc_0_us/ier$       | \
         <>:<NMasc_0_ynx/yngen>     $NMasc_0_ynx/yngen$    | \
         <>:<NMasc_0_x>             $NMasc_0_x$            | \
         <>:<NMasc_en_en>           $NMasc_en_en$          | \
         <>:<NMasc_es_$e>           $NMasc_es_\$e$         | \
         <>:<NMasc_es_$er>          $NMasc_es_\$er$        | \
         <>:<NMasc_es_as/anten~ss>  $NMasc_es_as/anten~ss$ | \
         <>:<NMasc_es_e>            $NMasc_es_e$           | \
         <>:<NMasc_es_e~ss>         $NMasc_es_e~ss$        | \
         <>:<NMasc_es_en>           $NMasc_es_en$          | \
         <>:<NMasc_es_er>           $NMasc_es_er$          | \
         <>:<NMasc_es_es>           $NMasc_es_es$          | \
         <>:<NMasc_es_s>            $NMasc_es_s$           | \
         <>:<NMasc_es_ex/izes>      $NMasc_es_ex/izes$     | \
         <>:<NMasc_es_us/een~ss>    $NMasc_es_us/een~ss$   | \
         <>:<NMasc_es_us/en~ss>     $NMasc_es_us/en~ss$    | \
         <>:<NMasc_es_us/i~ss>      $NMasc_es_us/i~ss$     | \
         <>:<NMasc_n_n>             $NMasc_n_n$            | \
         <>:<NMasc_ns_n>            $NMasc_ns_n$           | \
         <>:<NMasc_ns_$n>           $NMasc_ns_\$n$         | \
         <>:<NMasc_s_$>             $NMasc_s_\$$           | \
         <>:<NMasc_s_$e>            $NMasc_s_\$e$          | \
         <>:<NMasc_s_$er>           $NMasc_s_\$er$         | \
         <>:<NMasc_s_$x>            $NMasc_s_\$x$          | \
         <>:<NMasc_s_0>             $NMasc_s_0$            | \
         <>:<NMasc_s_e>             $NMasc_s_e$            | \
         <>:<NMasc_s_e/i>           $NMasc_s_e/i$          | \
         <>:<NMasc_s_en>            $NMasc_s_en$           | \
         <>:<NMasc_s_er>            $NMasc_s_er$           | \
         <>:<NMasc_s_es>            $NMasc_s_es$           | \
         <>:<NMasc_s_n>             $NMasc_s_n$            | \
         <>:<NMasc_s_nen>           $NMasc_s_nen$          | \
         <>:<NMasc_s_o/en>          $NMasc_s_o/en$         | \
         <>:<NMasc_s_o/i>           $NMasc_s_o/i$          | \
         <>:<NMasc_s_s>             $NMasc_s_s$            | \
         <>:<NMasc_s_x>             $NMasc_s_x$            | \
         <>:<NNeut-Adj>             $NNeut-Adj$            | \
         <>:<NNeut-Adj/Sg>          $NNeut-Adj/Sg$         | \
         <>:<NNeut-Inner>           $NNeut-Inner$          | \
         <>:<NNeut/Pl_0>            $NNeut/Pl_0$           | \
         <>:<NNeut/Pl_x>            $NNeut/Pl_x$           | \
         <>:<NNeut/Sg_0>            $NNeut/Sg_0$           | \
         <>:<NNeut/Sg_es>           $NNeut/Sg_es$          | \
         <>:<NNeut/Sg_es~ss>        $NNeut/Sg_es~ss$       | \
         <>:<NNeut/Sg_s>            $NNeut/Sg_s$           | \
         <>:<NNeut_0_0>             $NNeut_0_0$            | \
         <>:<NNeut_0_a/ata>         $NNeut_0_a/ata$        | \
         <>:<NNeut_0_a/en>          $NNeut_0_a/en$         | \
         <>:<NNeut_0_ans/antien>    $NNeut_0_ans/antien$   | \
         <>:<NNeut_0_ans/anzien>    $NNeut_0_ans/anzien$   | \
         <>:<NNeut_0_e>             $NNeut_0_e$            | \
         <>:<NNeut_0_e~ss>          $NNeut_0_e~ss$         | \
         <>:<NNeut_0_e/i>           $NNeut_0_e/i$          | \
         <>:<NNeut_0_en>            $NNeut_0_en$           | \
         <>:<NNeut_0_en/ina>        $NNeut_0_en/ina$       | \
         <>:<NNeut_0_ens/enzien>    $NNeut_0_ens/enzien$   | \
         <>:<NNeut_0_es>            $NNeut_0_es$           | \
         <>:<NNeut_0_nen>           $NNeut_0_nen$          | \
         <>:<NNeut_0_o/en>          $NNeut_0_o/en$         | \
         <>:<NNeut_0_o/i>           $NNeut_0_o/i$          | \
         <>:<NNeut_0_on/a>          $NNeut_0_on/a$         | \
         <>:<NNeut_0_on/en>         $NNeut_0_on/en$        | \
         <>:<NNeut_0_s>             $NNeut_0_s$            | \
         <>:<NNeut_0_um/a>          $NNeut_0_um/a$         | \
         <>:<NNeut_0_um/en>         $NNeut_0_um/en$        | \
         <>:<NNeut_0_us/en>         $NNeut_0_us/en$        | \
         <>:<NNeut_0_us/era>        $NNeut_0_us/era$       | \
         <>:<NNeut_0_us/ora>        $NNeut_0_us/ora$       | \
         <>:<NNeut_0_x>             $NNeut_0_x$            | \
         <>:<NNeut_ens_en>          $NNeut_ens_en$         | \
         <>:<NNeut_es_$e>           $NNeut_es_\$e$         | \
         <>:<NNeut_es_$er>          $NNeut_es_\$er$        | \
         <>:<NNeut_es_e>            $NNeut_es_e$           | \
         <>:<NNeut_es_e~ss>         $NNeut_es_e~ss$        | \
         <>:<NNeut_es_en>           $NNeut_es_en$          | \
         <>:<NNeut_es_er>           $NNeut_es_er$          | \
         <>:<NNeut_es_es>           $NNeut_es_es$          | \
         <>:<NNeut_es_ien>          $NNeut_es_ien$         | \
         <>:<NNeut_es_s>            $NNeut_es_s$           | \
         <>:<NNeut_s_$>             $NNeut_s_\$$           | \
         <>:<NNeut_s_$er>           $NNeut_s_\$er$         | \
         <>:<NNeut_s_0>             $NNeut_s_0$            | \
         <>:<NNeut_s_a>             $NNeut_s_a$            | \
         <>:<NNeut_s_a/ata>         $NNeut_s_a/ata$        | \
         <>:<NNeut_s_a/en>          $NNeut_s_a/en$         | \
         <>:<NNeut_s_e>             $NNeut_s_e$            | \
         <>:<NNeut_s_e/i>           $NNeut_s_e/i$          | \
         <>:<NNeut_s_en>            $NNeut_s_en$           | \
         <>:<NNeut_s_en/ina>        $NNeut_s_en/ina$       | \
         <>:<NNeut_s_ien>           $NNeut_s_ien$          | \
         <>:<NNeut_s_n>             $NNeut_s_n$            | \
         <>:<NNeut_s_nen>           $NNeut_s_nen$          | \
         <>:<NNeut_s_o/en>          $NNeut_s_o/en$         | \
         <>:<NNeut_s_o/i>           $NNeut_s_o/i$          | \
         <>:<NNeut_s_on/a>          $NNeut_s_on/a$         | \
         <>:<NNeut_s_on/en>         $NNeut_s_on/en$        | \
         <>:<NNeut_s_s>             $NNeut_s_s$            | \
         <>:<NNeut_s_um/a>          $NNeut_s_um/a$         | \
         <>:<NNeut_s_um/en>         $NNeut_s_um/en$        | \
         <>:<NNeut_s_x>             $NNeut_s_x$            | \
         <>:<NNoGend/Pl_0>          $NNoGend/Pl_0$         | \
         <>:<NNoGend/Pl_x>          $NNoGend/Pl_x$         | \
         <>:<Ord>                   $Ord$                  | \
         <>:<PIndInvar>             $PIndInvar$            | \
         <>:<Poss>                  $Poss$                 | \
         <>:<Poss-er>               $Poss-er$              | \
         <>:<Poss/Wk>               $Poss/Wk$              | \
         <>:<Poss/Wk-er>            $Poss/Wk-er$           | \
         <>:<Postp>                 $Postp$                | \
         <>:<PPro1AccPl>            $PPro1AccPl$           | \
         <>:<PPro1AccSg>            $PPro1AccSg$           | \
         <>:<PPro1DatPl>            $PPro1DatPl$           | \
         <>:<PPro1DatSg>            $PPro1DatSg$           | \
         <>:<PPro1GenPl>            $PPro1GenPl$           | \
         <>:<PPro1GenSg>            $PPro1GenSg$           | \
         <>:<PPro1NomPl>            $PPro1NomPl$           | \
         <>:<PPro1NomSg>            $PPro1NomSg$           | \
         <>:<PPro2AccPl>            $PPro2AccPl$           | \
         <>:<PPro2AccSg>            $PPro2AccSg$           | \
         <>:<PPro2DatPl>            $PPro2DatPl$           | \
         <>:<PPro2DatSg>            $PPro2DatSg$           | \
         <>:<PPro2GenPl>            $PPro2GenPl$           | \
         <>:<PPro2GenSg>            $PPro2GenSg$           | \
         <>:<PPro2NomPl>            $PPro2NomPl$           | \
         <>:<PPro2NomSg>            $PPro2NomSg$           | \
         <>:<PProFemAccSg>          $PProFemAccSg$         | \
         <>:<PProFemDatSg>          $PProFemDatSg$         | \
         <>:<PProFemGenSg>          $PProFemGenSg$         | \
         <>:<PProFemNomSg>          $PProFemNomSg$         | \
         <>:<PProMascAccSg>         $PProMascAccSg$        | \
         <>:<PProMascDatSg>         $PProMascDatSg$        | \
         <>:<PProMascGenSg>         $PProMascGenSg$        | \
         <>:<PProMascNomSg>         $PProMascNomSg$        | \
         <>:<PProNeutAccSg>         $PProNeutAccSg$        | \
         <>:<PProNeutAccSg-s>       $PProNeutAccSg-s$      | \
         <>:<PProNeutDatSg>         $PProNeutDatSg$        | \
         <>:<PProNeutGenSg>         $PProNeutGenSg$        | \
         <>:<PProNeutNomSg>         $PProNeutNomSg$        | \
         <>:<PProNeutNomSg-s>       $PProNeutNomSg-s$      | \
         <>:<PProNoGendAccPl>       $PProNoGendAccPl$      | \
         <>:<PProNoGendDatPl>       $PProNoGendDatPl$      | \
         <>:<PProNoGendGenPl>       $PProNoGendGenPl$      | \
         <>:<PProNoGendNomPl>       $PProNoGendNomPl$      | \
         <>:<PRecPl>                $PRecPl$               | \
         <>:<PRefl1AccSg>           $PRefl1AccSg$          | \
         <>:<PRefl1DatSg>           $PRefl1DatSg$          | \
         <>:<PRefl2AccSg>           $PRefl2AccSg$          | \
         <>:<PRefl2DatSg>           $PRefl2DatSg$          | \
         <>:<PRefl1Pl>              $PRefl1Pl$             | \
         <>:<PRefl2Pl>              $PRefl2Pl$             | \
         <>:<PRefl3>                $PRefl3$               | \
         <>:<Prep>                  $Prep$                 | \
         <>:<Prep+Art-m>            $Prep+Art-m$           | \
         <>:<Prep+Art-n>            $Prep+Art-n$           | \
         <>:<Prep+Art-r>            $Prep+Art-r$           | \
         <>:<Prep+Art-s>            $Prep+Art-s$           | \
         <>:<ProAdv>                $ProAdv$               | \
         <>:<PtclAdj>               $PtclAdj$              | \
         <>:<PtclNeg>               $PtclNeg$              | \
         <>:<Ptcl-zu>               $Ptcl-zu$              | \
         <>:<Rel>                   $Rel$                  | \
         <>:<Rel-welch>             $Rel-welch$            | \
         <>:<RProMascAccSg>         $RProMascAccSg$        | \
         <>:<RProMascDatSg>         $RProMascDatSg$        | \
         <>:<RProMascGenSg>         $RProMascGenSg$        | \
         <>:<RProMascNomSg>         $RProMascNomSg$        | \
         <>:<RProNeutAccSg>         $RProNeutAccSg$        | \
         <>:<RProNeutDatSg>         $RProNeutDatSg$        | \
         <>:<RProNeutGenSg>         $RProNeutGenSg$        | \
         <>:<RProNeutNomSg>         $RProNeutNomSg$        | \
         <>:<Roman>                 $Roman$                | \
         <>:<VAImpPl>               $VAImpPl$              | \
         <>:<VAImpSg>               $VAImpSg$              | \
         <>:<VAPastIndPl>           $VAPastIndPl$          | \
         <>:<VAPastIndSg>           $VAPastIndSg$          | \
         <>:<VAPastSubj2>           $VAPastSubj2$          | \
         <>:<VAPres13PlInd>         $VAPres13PlInd$        | \
         <>:<VAPres1SgInd>          $VAPres1SgInd$         | \
         <>:<VAPres2PlInd>          $VAPres2PlInd$         | \
         <>:<VAPres2SgInd>          $VAPres2SgInd$         | \
         <>:<VAPres2SgSubj>         $VAPres2SgSubj$        | \
         <>:<VAPres3SgInd>          $VAPres3SgInd$         | \
         <>:<VAPresSubjPl>          $VAPresSubjPl$         | \
         <>:<VAPresSubjSg>          $VAPresSubjSg$         | \
         <>:<VInf-en>               $VInf-en$              | \
         <>:<VInf-n>                $VInf-n$               | \
         <>:<VInf>                  $VInf$                 | \
         <>:<VMPast>                $VMPast$               | \
         <>:<VMPast><>:<haben>      $VMPast+haben$         | \
         <>:<VMPast><>:<sein>       $VMPast+sein$          | \
         <>:<VMPastSubj>            $VMPastSubj$           | \
         <>:<VMPresPl>              $VMPresPl$             | \
         <>:<VMPresSg>              $VMPresSg$             | \
         <>:<VPart>                 $VPart$                | \
         <>:<VPPast>                $VPPast$               | \
         <>:<VPPast><>:<haben>      $VPPast+haben$         | \
         <>:<VPPast><>:<sein>       $VPPast+sein$          | \
         <>:<VPastIndIrreg>         $VPastIndIrreg$        | \
         <>:<VPastIndReg>           $VPastIndReg$          | \
         <>:<VPastIndStr>           $VPastIndStr$          | \
         <>:<VPastSubjStr>          $VPastSubjStr$         | \
         <>:<VPPres>                $VPPres$               | \
         <>:<VPresSubj>             $VPresSubj$            | \
         <>:<VVPastIndReg>          $VVPastIndReg$         | \
         <>:<VVPastIndStr>          $VVPastIndStr$         | \
         <>:<VVPastStr>             $VVPastStr$            | \
         <>:<VVPastSubjOld>         $VVPastSubjOld$        | \
         <>:<VVPastSubjReg>         $VVPastSubjReg$        | \
         <>:<VVPastSubjStr>         $VVPastSubjStr$        | \
         <>:<VVPP-en>               $VVPP-en$              | \
         <>:<VVPP-en><>:<haben>     $VVPP-en+haben$        | \
         <>:<VVPP-en><>:<sein>      $VVPP-en+sein$         | \
         <>:<VVPP-t>                $VVPP-t$               | \
         <>:<VVPP-t><>:<haben>      $VVPP-t+haben$         | \
         <>:<VVPP-t><>:<sein>       $VVPP-t+sein$          | \
         <>:<VVPres>                $VVPres$               | \
         <>:<VVPres1>               $VVPres1$              | \
         <>:<VVPres1_Imp>           $VVPres1_Imp$          | \
         <>:<VVPres2>               $VVPres2$              | \
         <>:<VVPres2_Imp>           $VVPres2_Imp$          | \
         <>:<VVPres2_Imp0>          $VVPres2_Imp0$         | \
         <>:<VVPres2t>              $VVPres2t$             | \
         <>:<VVPres2t_Imp0>         $VVPres2t_Imp0$        | \
         <>:<VVReg>                 $VVReg$                | \
         <>:<VVReg><>:<haben>       $VVReg+haben$          | \
         <>:<VVReg><>:<sein>        $VVReg+sein$           | \
         <>:<VVReg-el-er>           $VVReg-el-er$          | \
         <>:<VVReg-el-er><>:<haben> $VVReg-el-er+haben$    | \
         <>:<VVReg-el-er><>:<sein>  $VVReg-el-er+sein$     | \
         <>:<WAdv>                  $WAdv$                 | \
         <>:<W-welch>               $W-welch$              | \
         <>:<WProMascAccSg>         $WProMascAccSg$        | \
         <>:<WProMascDatSg>         $WProMascDatSg$        | \
         <>:<WProMascGenSg>         $WProMascGenSg$        | \
         <>:<WProMascNomSg>         $WProMascNomSg$        | \
         <>:<WProNeutAccSg>         $WProNeutAccSg$        | \
         <>:<WProNeutDatSg>         $WProNeutDatSg$        | \
         <>:<WProNeutGenSg>         $WProNeutGenSg$        | \
         <>:<WProNeutNomSg>         $WProNeutNomSg$


% inflection filter

ALPHABET = [#char# #surface-trigger# #orth-trigger# #phon-trigger# \
            #morph-trigger# #boundary-trigger# <ge><zu>]

$=INFL$ = [#inflection#]:<>

$=AUX$ = [#auxiliary#]:<>

$InflFilter$ = (.* $=INFL$ $=AUX$ $=INFL$ $=AUX$ .*) | \
               (.* $=INFL$ $=INFL$ .*)
