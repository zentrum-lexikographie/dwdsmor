% infl.fst
% Version 9.0
% Andreas Nolda 2024-10-01

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

$SS$ = <>:<dbl(s)>


% nouns

$NGenSgSuff_0$ = {<Nom><Sg>}:{} | \
                 {<Acc><Sg>}:{} | \
                 {<Dat><Sg>}:{} | \
                 {<Gen><Sg>}:{}

$NGenSgSuff_en$ = {<Nom><Sg>}:{}        | \
                  {<Acc><Sg>}:{<SB>en}  | \
                  {<Acc><Sg><NonSt>}:{} | \
                  {<Dat><Sg>}:{<SB>en}  | \
                  {<Dat><Sg><NonSt>}:{} | \ % cf. Duden-Grammatik (2016: § 333)
                  {<Gen><Sg>}:{<SB>en}

$NGenSgSuff_n$ = {<Nom><Sg>}:{}      | \
                 {<Acc><Sg>}:{<SB>n} | \
                 {<Dat><Sg>}:{<SB>n} | \
                 {<Gen><Sg>}:{<SB>n}

$NGenSgSuff_es$ = {<Nom><Sg>}:{}           | \
                  {<Acc><Sg>}:{}           | \
                  {<Dat><Sg>}:{}           | \
                  {<Dat><Sg><Old>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 317)
                  {<Gen><Sg>}:{<SB>es<del(e)|Gen>}

$NGenSgSuff_s$ = {<Nom><Sg>}:{} | \
                 {<Acc><Sg>}:{} | \
                 {<Dat><Sg>}:{} | \
                 {<Gen><Sg>}:{<SB>s}

$NGenSgSuff_ns$ = {<Nom><Sg>}:{}      | \
                  {<Acc><Sg>}:{<SB>n} | \
                  {<Dat><Sg>}:{<SB>n} | \
                  {<Gen><Sg>}:{<SB>ns}

$NGenSgSuff_ens$ = {<Nom><Sg>}:{}       | \
                   {<Acc><Sg>}:{}       | \
                   {<Dat><Sg>}:{<SB>en} | \
                   {<Gen><Sg>}:{<SB>ens}

$NDatPlSuff_0$ = {<Nom><Pl>}:{} | \
                 {<Acc><Pl>}:{} | \
                 {<Dat><Pl>}:{} | \
                 {<Gen><Pl>}:{}

$NDatPlSuff_n$ = {<Nom><Pl>}:{}      | \
                 {<Acc><Pl>}:{}      | \
                 {<Dat><Pl>}:{<SB>n} | \
                 {<Gen><Pl>}:{}


% masculine nouns

% Fiskus, Fiskus
$NMasc|Sg_0$ = {<+NN><Masc>}:{} $NGenSgSuff_0$

% Abwasch, Abwasch(e)s; Glanz, Glanzes
$NMasc|Sg_es$ = {<+NN><Masc>}:{} $NGenSgSuff_es$

% Hagel, Hagels; Adel, Adels
$NMasc|Sg_s$ = {<+NN><Masc>}:{} $NGenSgSuff_s$

% Unglaube, Unglaubens
$NMasc|Sg_ns$ = {<+NN><Masc>}:{} $NGenSgSuff_ns$

% Bauten, Bauten (suppletive plural)
$NMasc|Pl_0$ = {<+NN><Masc>}:{} $NDatPlSuff_0$

% Revers, Revers, Revers, Revers
$NMasc_0_0_0$ = {<+NN><Masc>}:{} $NGenSgSuff_0$ | \
                {<+NN><Masc>}:{} $NDatPlSuff_0$

% Dezember, Dezember, Dezember, Dezembern
$NMasc_0_0_n$ = {<+NN><Masc>}:{} $NGenSgSuff_0$ | \
                {<+NN><Masc>}:{} $NDatPlSuff_n$

% Kodex, Kodex, Kodexe, Kodexen
$NMasc_0_e_n$ = {<+NN><Masc>}:{}      $NGenSgSuff_0$ | \
                {<+NN><Masc>}:{<SB>e} $NDatPlSuff_n$

% Nimbus, Nimbus, Nimbusse, Nimbussen
$NMasc_0_e_n~ss$ = $SS$ $NMasc_0_e_n$

% Bypass, Bypass, Bypässe, Bypässen
$NMasc_0_\$e_n$ = {<+NN><Masc>}:{}           $NGenSgSuff_0$ | \
                  {<+NN><Masc>}:{<uml><SB>e} $NDatPlSuff_n$

% Obelisk, Obelisk, Obelisken, Obelisken
$NMasc_0_en_0$ = {<+NN><Masc>}:{}       $NGenSgSuff_0$ | \
                 {<+NN><Masc>}:{<SB>en} $NDatPlSuff_0$

% Kanon, Kanon, Kanones, Kanones; Sandwich, Sandwich, Sandwiches, Sandwiches (masculine)
$NMasc_0_es_0$ = {<+NN><Masc>}:{}       $NGenSgSuff_0$ | \
                 {<+NN><Masc>}:{<SB>es} $NDatPlSuff_0$

% Embryo, Embryo, Embryonen, Embryonen (masculine)
$NMasc_0_nen_0$ = {<+NN><Masc>}:{}        $NGenSgSuff_0$ | \
                  {<+NN><Masc>}:{n<SB>en} $NDatPlSuff_0$

% Intercity, Intercity, Intercitys, Intercitys
$NMasc_0_s_0$ = {<+NN><Masc>}:{}      $NGenSgSuff_0$ | \
                {<+NN><Masc>}:{<SB>s} $NDatPlSuff_0$

% Atlas, Atlas, Atlanten, Atlanten
$NMasc_0_as/anten_0$ = {<+NN><Masc>}:{}                      $NGenSgSuff_0$ | \
                       {<+NN><Masc>}:{<del(VC)|Pl>ant<SB>en} $NDatPlSuff_0$

% Carabiniere, Carabiniere, Carabinieri, Carabinieri
$NMasc_0_e/i_0$ = {<+NN><Masc>}:{}                  $NGenSgSuff_0$ | \
                  {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Index, Index, Indizes, Indizes
$NMasc_0_ex/izes_0$ = {<+NN><Masc>}:{}                     $NGenSgSuff_0$ | \
                      {<+NN><Masc>}:{<del(VC)|Pl>iz<SB>es} $NDatPlSuff_0$

% Saldo, Saldo, Salden, Salden
$NMasc_0_o/en_0$ = {<+NN><Masc>}:{}                   $NGenSgSuff_0$ | \
                   {<+NN><Masc>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Espresso, Espresso, Espressi, Espressi
$NMasc_0_o/i_0$ = {<+NN><Masc>}:{}                  $NGenSgSuff_0$ | \
                  {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Heros, Heros, Heroen, Heroen
$NMasc_0_os/oen_0$ = {<+NN><Masc>}:{}                    $NGenSgSuff_0$ | \
                     {<+NN><Masc>}:{<del(VC)|Pl>o<SB>en} $NDatPlSuff_0$

% Kustos, Kustos, Kustoden, Kustoden
$NMasc_0_os/oden_0$ = {<+NN><Masc>}:{}                     $NGenSgSuff_0$ | \
                      {<+NN><Masc>}:{<del(VC)|Pl>od<SB>en} $NDatPlSuff_0$

% Topos, Topos, Topoi, Topoi
$NMasc_0_os/oi_0$ = {<+NN><Masc>}:{}                   $NGenSgSuff_0$ | \
                    {<+NN><Masc>}:{<del(VC)|Pl>o<SB>i} $NDatPlSuff_0$

% Kursus, Kursus, Kurse, Kursen
$NMasc_0_us/e_n$ = {<+NN><Masc>}:{}                  $NGenSgSuff_0$ | \
                   {<+NN><Masc>}:{<del(VC)|Pl><SB>e} $NDatPlSuff_n$

% Virus, Virus, Viren, Viren; Mythos, Mythos, Mythen, Mythen
$NMasc_0_us/en_0$ = {<+NN><Masc>}:{}                   $NGenSgSuff_0$ | \
                    {<+NN><Masc>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Kaktus, Kaktus, Kakteen, Kakteen
$NMasc_0_us/een_0$ = {<+NN><Masc>}:{}                    $NGenSgSuff_0$ | \
                     {<+NN><Masc>}:{<del(VC)|Pl>e<SB>en} $NDatPlSuff_0$

% Intimus, Intimus, Intimi, Intimi
$NMasc_0_us/i_0$ = {<+NN><Masc>}:{}                  $NGenSgSuff_0$ | \
                   {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Dinosaurus, Dinosaurus, Dinosaurier, Dinosauriern
$NMasc_0_us/ier_n$ = {<+NN><Masc>}:{}                    $NGenSgSuff_0$ | \
                     {<+NN><Masc>}:{<del(VC)|Pl>i<SB>er} $NDatPlSuff_n$

% Larynx, Larynx, Laryngen, Laryngen
$NMasc_0_ynx/yngen_0$ = {<+NN><Masc>}:{}                      $NGenSgSuff_0$ | \
                        {<+NN><Masc>}:{<del(VC)|Pl>yng<SB>en} $NDatPlSuff_0$

% Tag, Tag(e)s, Tage, Tagen; Kodex, Kodexes, Kodexe, Kodexen
$NMasc_es_e_n$ = {<+NN><Masc>}:{}      $NGenSgSuff_es$ | \
                 {<+NN><Masc>}:{<SB>e} $NDatPlSuff_n$

% Bus, Busses, Busse, Bussen
$NMasc_es_e_n~ss$ = $SS$ $NMasc_es_e_n$

% Arzt, Arzt(e)s, Ärzte, Ärzten
$NMasc_es_\$e_n$ = {<+NN><Masc>}:{}           $NGenSgSuff_es$ | \
                   {<+NN><Masc>}:{<uml><SB>e} $NDatPlSuff_n$

% Geist, Geist(e)s, Geister, Geistern
$NMasc_es_er_n$ = {<+NN><Masc>}:{}       $NGenSgSuff_es$ | \
                  {<+NN><Masc>}:{<SB>er} $NDatPlSuff_n$

% Gott, Gott(e)s, Götter, Göttern
$NMasc_es_\$er_n$ = {<+NN><Masc>}:{}            $NGenSgSuff_es$ | \
                    {<+NN><Masc>}:{<uml><SB>er} $NDatPlSuff_n$

% Fleck, Fleck(e)s, Flecken, Flecken
$NMasc_es_en_0$ = {<+NN><Masc>}:{}       $NGenSgSuff_es$ | \
                  {<+NN><Masc>}:{<SB>en} $NDatPlSuff_0$

% Bugfix, Bugfix(e)s, Bugfixes, Bugfixes
$NMasc_es_es_0$ = {<+NN><Masc>}:{}       $NGenSgSuff_es$ | \
                  {<+NN><Masc>}:{<SB>es} $NDatPlSuff_0$

% Park, Park(e)s, Parks, Parks
$NMasc_es_s_0$ = {<+NN><Masc>}:{}      $NGenSgSuff_es$ | \
                 {<+NN><Masc>}:{<SB>s} $NDatPlSuff_0$

% Atlas, Atlasses, Atlanten, Atlanten
$NMasc_es_as/anten_0~ss$ = $SS$ {<+NN><Masc>}:{}                      $NGenSgSuff_es$ | \
                                {<+NN><Masc>}:{<del(VC)|Pl>ant<SB>en} $NDatPlSuff_0$

% Index, Indexes, Indizes, Indizes
$NMasc_es_ex/izes_0$ = {<+NN><Masc>}:{}                     $NGenSgSuff_es$ | \
                       {<+NN><Masc>}:{<del(VC)|Pl>iz<SB>es} $NDatPlSuff_0$

% Virus, Virusses, Viren, Viren
$NMasc_es_us/en_0~ss$ = $SS$ {<+NN><Masc>}:{}                   $NGenSgSuff_es$ | \
                             {<+NN><Masc>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Kaktus, Kaktusses, Kakteen, Kakteen
$NMasc_es_us/een_0~ss$ = $SS$ {<+NN><Masc>}:{}                    $NGenSgSuff_es$ | \
                              {<+NN><Masc>}:{<del(VC)|Pl>e<SB>en} $NDatPlSuff_0$

% Intimus, Intimusse, Intimi, Intimi
$NMasc_es_us/i_0~ss$ = $SS$ {<+NN><Masc>}:{}                  $NGenSgSuff_es$ | \
                            {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Wagen, Wagens, Wagen, Wagen
$NMasc_s_0_0$ = {<+NN><Masc>}:{} $NGenSgSuff_s$ | \
                {<+NN><Masc>}:{} $NDatPlSuff_0$

% Garten, Gartens, Gärten, Gärten; Schaden, Schadens, Schäden
$NMasc_s_\$_0$ = {<+NN><Masc>}:{}      $NGenSgSuff_s$ | \
                 {<+NN><Masc>}:{<uml>} $NDatPlSuff_0$

% Engel, Engels, Engel, Engeln; Dezember, Dezembers, Dezember, Dezembern
$NMasc_s_0_n$ = {<+NN><Masc>}:{} $NGenSgSuff_s$ | \
                {<+NN><Masc>}:{} $NDatPlSuff_n$

% Apfel, Apfels, Äpfel, Äpfeln; Vater, Vaters, Väter, Vätern
$NMasc_s_\$_n$ = {<+NN><Masc>}:{}      $NGenSgSuff_s$ | \
                 {<+NN><Masc>}:{<uml>} $NDatPlSuff_n$

% Drilling, Drillings, Drillinge, Drillingen
$NMasc_s_e_n$ = {<+NN><Masc>}:{}      $NGenSgSuff_s$ | \
                {<+NN><Masc>}:{<SB>e} $NDatPlSuff_n$

% Tenor, Tenors, Tenöre, Tenören
$NMasc_s_\$e_n$ = {<+NN><Masc>}:{}           $NGenSgSuff_s$ | \
                  {<+NN><Masc>}:{<uml><SB>e} $NDatPlSuff_n$

% Ski, Skis, Skier, Skiern
$NMasc_s_er_n$ = {<+NN><Masc>}:{}       $NGenSgSuff_s$ | \
                 {<+NN><Masc>}:{<SB>er} $NDatPlSuff_n$

% Irrtum, Irrtums, Irrtümer, Irrtümern
$NMasc_s_\$er_n$ = {<+NN><Masc>}:{}            $NGenSgSuff_s$ | \
                   {<+NN><Masc>}:{<uml><SB>er} $NDatPlSuff_n$

% Zeh, Zehs, Zehen, Zehen
$NMasc_s_en_0$ = {<+NN><Masc>}:{}       $NGenSgSuff_s$ | \
                 {<+NN><Masc>}:{<SB>en} $NDatPlSuff_0$

% Kanon, Kanons, Kanones, Kanones
$NMasc_s_es_0$ = {<+NN><Masc>}:{}       $NGenSgSuff_s$ | \
               {<+NN><Masc>}:{<SB>es} $NDatPlSuff_0$

% Muskel, Muskels, Muskeln, Muskeln; See, Sees, Seen, Seen
$NMasc_s_n_0$ = {<+NN><Masc>}:{}      $NGenSgSuff_s$ | \
                {<+NN><Masc>}:{<SB>n} $NDatPlSuff_0$

% Embryo, Embryos, Embryonen, Embryonen (masculine)
$NMasc_s_nen_0$ = {<+NN><Masc>}:{}        $NGenSgSuff_s$ | \
                  {<+NN><Masc>}:{n<SB>en} $NDatPlSuff_0$

% Chef, Chefs, Chefs, Chefs; Bankier, Bankiers, Bankiers, Bankiers
$NMasc_s_s_0$ = {<+NN><Masc>}:{}      $NGenSgSuff_s$ | \
                {<+NN><Masc>}:{<SB>s} $NDatPlSuff_0$

% Carabiniere, Carabinieres, Carabinieri, Carabinieri
$NMasc_s_e/i_0$ = {<+NN><Masc>}:{}                  $NGenSgSuff_s$ | \
                  {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Saldo, Saldos, Salden, Salden
$NMasc_s_o/en_0$ = {<+NN><Masc>}:{}                   $NGenSgSuff_s$ | \
                   {<+NN><Masc>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Espresso, Espressos, Espressi, Espressi
$NMasc_s_o/i_0$ = {<+NN><Masc>}:{}                  $NGenSgSuff_s$ | \
                  {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Fels, Felsen, Felsen, Felsen; Mensch, Menschen, Menschen, Menschen
$NMasc_en_en_0$ = {<+NN><Masc>}:{}       $NGenSgSuff_en$ | \
                  {<+NN><Masc>}:{<SB>en} $NDatPlSuff_0$

% Affe, Affen, Affen, Affen; Bauer, Bauern, Bauern, Bauern
$NMasc_n_n_0$ = {<+NN><Masc>}:{}      $NGenSgSuff_n$ | \
                {<+NN><Masc>}:{<SB>n} $NDatPlSuff_0$

% Name, Namens, Namen, Namen; Buchstabe, Buchstabens, Buchstaben, Buchstaben
$NMasc_ns_n_0$ = {<+NN><Masc>}:{}      $NGenSgSuff_ns$ | \
                 {<+NN><Masc>}:{<SB>n} $NDatPlSuff_0$

% Schade, Schadens, Schäden, Schäden
$NMasc_ns_\$n_0$ = {<+NN><Masc>}:{}           $NGenSgSuff_ns$ | \
                   {<+NN><Masc>}:{<uml><SB>n} $NDatPlSuff_0$

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
$NNeut|Sg_0$ = {<+NN><Neut>}:{} $NGenSgSuff_0$

% Ausland, Ausland(e)s
$NNeut|Sg_es$ = {<+NN><Neut>}:{} $NGenSgSuff_es$

% Verständnis, Verständnisses
$NNeut|Sg_es~ss$ = $SS$ {<+NN><Neut>}:{} $NGenSgSuff_es$

% Abitur, Abiturs
$NNeut|Sg_s$ = {<+NN><Neut>}:{} $NGenSgSuff_s$

% Pluraliatantum, Pluraliatantum (suppletive plural)
$NNeut|Pl_0$ = {<+NN><Neut>}:{} $NDatPlSuff_0$

% Viecher, Viechern (suppletive plural)
$NNeut|Pl_n$ = {<+NN><Neut>}:{} $NDatPlSuff_n$

% Relais, Relais, Relais, Relais
$NNeut_0_0_0$ = {<+NN><Neut>}:{} $NGenSgSuff_0$ | \
                {<+NN><Neut>}:{} $NDatPlSuff_0$

% Gefolge, Gefolge, Gefolge, Gefolgen
$NNeut_0_0_n$ = {<+NN><Neut>}:{} $NGenSgSuff_0$ | \
                {<+NN><Neut>}:{} $NDatPlSuff_n$

% Bakschisch, Bakschisch, Bakschische, Bakschischen
$NNeut_0_e_n$ = {<+NN><Neut>}:{}      $NGenSgSuff_0$ | \
                {<+NN><Neut>}:{<SB>e} $NDatPlSuff_n$

% Rhinozeros, Rhinozeros, Rhinozerosse, Rhinozerossen
$NNeut_0_e_n~ss$ = $SS$ $NNeut_0_e_n$

% Remis, Remis, Remisen, Remisen
$NNeut_0_en_0$ = {<+NN><Neut>}:{}       $NGenSgSuff_0$ | \
                 {<+NN><Neut>}:{<SB>en} $NDatPlSuff_0$

% Sandwich, Sandwich, Sandwiches, Sandwiches (neuter)
$NNeut_0_es_0$ = {<+NN><Neut>}:{}       $NGenSgSuff_0$ | \
                 {<+NN><Neut>}:{<SB>es} $NDatPlSuff_0$

% Embryo, Embryo, Embryonen, Embryonen (neuter)
$NNeut_0_nen_0$ = {<+NN><Neut>}:{}        $NGenSgSuff_0$ | \
                  {<+NN><Neut>}:{n<SB>en} $NDatPlSuff_0$

% College, College, Colleges, Colleges
$NNeut_0_s_0$ = {<+NN><Neut>}:{}      $NGenSgSuff_0$ | \
                {<+NN><Neut>}:{<SB>s} $NDatPlSuff_0$

% Komma, Komma, Kommata, Kommata
$NNeut_0_a/ata_0$ = {<+NN><Neut>}:{}       $NGenSgSuff_0$ | \
                    {<+NN><Neut>}:{t<SB>a} $NDatPlSuff_0$

% Dogma, Dogma, Dogmen, Dogmen
$NNeut_0_a/en_0$ = {<+NN><Neut>}:{}                   $NGenSgSuff_0$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Determinans, Determinans, Determinantien, Determinantien
$NNeut_0_ans/antien_0$ = {<+NN><Neut>}:{}                       $NGenSgSuff_0$ | \
                         {<+NN><Neut>}:{<del(VC)|Pl>anti<SB>en} $NDatPlSuff_0$

% Stimulans, Stimulans, Stimulanzien, Stimulanzien
$NNeut_0_ans/anzien_0$ = {<+NN><Neut>}:{}                       $NGenSgSuff_0$ | \
                         {<+NN><Neut>}:{<del(VC)|Pl>anzi<SB>en} $NDatPlSuff_0$

% Ricercare, Ricercare, Ricercari, Ricercari
$NNeut_0_e/i_0$ = {<+NN><Neut>}:{}                  $NGenSgSuff_0$ | \
                  {<+NN><Neut>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Numerale, Numerale, Numeralia, Numeralia
$NNeut_0_e/ia_0$ = {<+NN><Neut>}:{}                   $NGenSgSuff_0$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>ia} $NDatPlSuff_0$

% Numerale, Numerale, Numeralien, Numeralien
$NNeut_0_e/ien_0$ = {<+NN><Neut>}:{}                    $NGenSgSuff_0$ | \
                    {<+NN><Neut>}:{<del(VC)|Pl><SB>ien} $NDatPlSuff_0$

% Examen, Examen, Examina, Examina
$NNeut_0_en/ina_0$ = {<+NN><Neut>}:{}                    $NGenSgSuff_0$ | \
                     {<+NN><Neut>}:{<del(VC)|Pl>in<SB>a} $NDatPlSuff_0$

% Reagens, Reagens, Reagenzien, Reagenzien
$NNeut_0_ens/enzien_0$ = {<+NN><Neut>}:{}                       $NGenSgSuff_0$ | \
                         {<+NN><Neut>}:{<del(VC)|Pl>enzi<SB>en} $NDatPlSuff_0$

% Konto, Konto, Konten, Konten
$NNeut_0_o/en_0$ = {<+NN><Neut>}:{}                   $NGenSgSuff_0$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Intermezzo, Intermezzo, Intermezzi, Intermezzi
$NNeut_0_o/i_0$ = {<+NN><Neut>}:{}                  $NGenSgSuff_0$ | \
                  {<+NN><Neut>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Oxymoron, Oxymoron, Oxymora, Oxymora
$NNeut_0_on/a_0$ = {<+NN><Neut>}:{}                  $NGenSgSuff_0$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>a} $NDatPlSuff_0$

% Stadion, Stadion, Stadien, Stadien
$NNeut_0_on/en_0$ = {<+NN><Neut>}:{}                   $NGenSgSuff_0$ | \
                    {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Aktivum, Aktivum, Aktiva, Aktiva
$NNeut_0_um/a_0$ = {<+NN><Neut>}:{}                  $NGenSgSuff_0$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>a} $NDatPlSuff_0$

% Museum, Museum, Museen, Museen
$NNeut_0_um/en_0$ = {<+NN><Neut>}:{}                   $NGenSgSuff_0$ | \
                    {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Virus, Virus, Viren, Viren; Epos, Epos, Epen, Epen
$NNeut_0_us/en_0$ = {<+NN><Neut>}:{}                   $NGenSgSuff_0$ | \
                    {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Genus, Genus, Genera, Genera
$NNeut_0_us/era_0$ = {<+NN><Neut>}:{}                    $NGenSgSuff_0$ | \
                     {<+NN><Neut>}:{<del(VC)|Pl>er<SB>a} $NDatPlSuff_0$

% Tempus, Tempus, Tempora, Tempora
$NNeut_0_us/ora_0$ = {<+NN><Neut>}:{}                    $NGenSgSuff_0$ | \
                     {<+NN><Neut>}:{<del(VC)|Pl>or<SB>a} $NDatPlSuff_0$

% Spiel, Spiel(e)s, Spiele, Spielen; Bakschisch, Bakschisch(e)s, Bakschische, Bakschischen
$NNeut_es_e_n$ = {<+NN><Neut>}:{}      $NGenSgSuff_es$ | \
                 {<+NN><Neut>}:{<SB>e} $NDatPlSuff_n$

% Zeugnis, Zeugnisses, Zeugnisse, Zeugnissen; Rhinozeros, Rhinozerosses, Rhinozerosse, Rhinozerossen
$NNeut_es_e_n~ss$ = $SS$ $NNeut_es_e_n$

% Floß, Floßes, Flöße, Flößen
$NNeut_es_\$e_n$ = {<+NN><Neut>}:{}           $NGenSgSuff_es$ | \
                   {<+NN><Neut>}:{<uml><SB>e} $NDatPlSuff_n$

% Schild, Schild(e)s, Schilder, Schildern
$NNeut_es_er_n$ = {<+NN><Neut>}:{}       $NGenSgSuff_es$ | \
                  {<+NN><Neut>}:{<SB>er} $NDatPlSuff_n$

% Buch, Buch(e)s, Bücher, Büchern
$NNeut_es_\$er_n$ = {<+NN><Neut>}:{}            $NGenSgSuff_es$ | \
                    {<+NN><Neut>}:{<uml><SB>er} $NDatPlSuff_n$

% Bett, Bett(e)s, Betten, Betten
$NNeut_es_en_0$ = {<+NN><Neut>}:{}       $NGenSgSuff_es$ | \
                {<+NN><Neut>}:{<SB>en} $NDatPlSuff_0$

% Match, Match(e)s, Matches, Matches
$NNeut_es_es_0$ = {<+NN><Neut>}:{}       $NGenSgSuff_es$ | \
                  {<+NN><Neut>}:{<SB>es} $NDatPlSuff_0$

% Tablett, Tablett(e)s, Tabletts, Tabletts
$NNeut_es_s_0$ = {<+NN><Neut>}:{}      $NGenSgSuff_es$ | \
                 {<+NN><Neut>}:{<SB>s} $NDatPlSuff_0$

% Indiz, Indizes, Indizien, Indizien
$NNeut_es_ien_0$ = {<+NN><Neut>}:{}        $NGenSgSuff_es$ | \
                   {<+NN><Neut>}:{i<SB>en} $NDatPlSuff_0$

% Almosen, Almosens, Almosen, Almosen
$NNeut_s_0_0$ = {<+NN><Neut>}:{} $NGenSgSuff_s$ | \
                {<+NN><Neut>}:{} $NDatPlSuff_0$

% Feuer, Feuers, Feuer, Feuern; Gefolge, Gefolges, Gefolge, Gefolgen
$NNeut_s_0_n$ = {<+NN><Neut>}:{} $NGenSgSuff_s$ | \
                {<+NN><Neut>}:{} $NDatPlSuff_n$

% Kloster, Klosters, Klöster, Klöstern
$NNeut_s_\$_n$ = {<+NN><Neut>}:{}      $NGenSgSuff_s$ | \
                 {<+NN><Neut>}:{<uml>} $NDatPlSuff_n$

% Reflexiv, Reflexivs, Reflexiva, Reflexiva
$NNeut_s_a_0$ = {<+NN><Neut>}:{}      $NGenSgSuff_s$ | \
                {<+NN><Neut>}:{<SB>a} $NDatPlSuff_0$

% Dreieck, Dreiecks, Dreiecke, Dreiecken
$NNeut_s_e_n$ = {<+NN><Neut>}:{}      $NGenSgSuff_s$ | \
                {<+NN><Neut>}:{<SB>e} $NDatPlSuff_n$

% Spital, Spitals, Spitäler, Spitälern
$NNeut_s_\$er_n$ = {<+NN><Neut>}:{}            $NGenSgSuff_s$ | \
                   {<+NN><Neut>}:{<uml><SB>er} $NDatPlSuff_n$

% Juwel, Juwels, Juwelen, Juwelen
$NNeut_s_en_0$ = {<+NN><Neut>}:{}       $NGenSgSuff_s$ | \
                 {<+NN><Neut>}:{<SB>en} $NDatPlSuff_0$

% Auge, Auges, Augen, Augen
$NNeut_s_n_0$ = {<+NN><Neut>}:{}      $NGenSgSuff_s$ | \
                {<+NN><Neut>}:{<SB>n} $NDatPlSuff_0$

% Embryo, Embryos, Embryonen, Embryonen (neuter)
$NNeut_s_nen_0$ = {<+NN><Neut>}:{}        $NGenSgSuff_s$ | \
                  {<+NN><Neut>}:{n<SB>en} $NDatPlSuff_0$

% Adverb, Adverbs, Adverbien, Adverbien
$NNeut_s_ien_0$ = {<+NN><Neut>}:{}        $NGenSgSuff_s$ | \
                  {<+NN><Neut>}:{i<SB>en} $NDatPlSuff_0$

% Sofa, Sofas, Sofas, Sofas; College, Colleges, Colleges, Colleges
$NNeut_s_s_0$ = {<+NN><Neut>}:{}      $NGenSgSuff_s$ | \
                {<+NN><Neut>}:{<SB>s} $NDatPlSuff_0$

% Komma, Kommas, Kommata, Kommata
$NNeut_s_a/ata_0$ = {<+NN><Neut>}:{}       $NGenSgSuff_s$ | \
                    {<+NN><Neut>}:{t<SB>a} $NDatPlSuff_0$

% Dogma, Dogmas, Dogmen, Dogmen
$NNeut_s_a/en_0$ = {<+NN><Neut>}:{}                   $NGenSgSuff_s$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Ricercare, Ricercares, Ricercari, Ricercari
$NNeut_s_e/i_0$ = {<+NN><Neut>}:{}                  $NGenSgSuff_s$ | \
                  {<+NN><Neut>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Numerale, Numerales, Numeralia, Numeralia
$NNeut_s_e/ia_0$ = {<+NN><Neut>}:{}                   $NGenSgSuff_s$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>ia} $NDatPlSuff_0$

% Numerale, Numerales, Numeralien, Numeralien
$NNeut_s_e/ien_0$ = {<+NN><Neut>}:{}                    $NGenSgSuff_s$ | \
                    {<+NN><Neut>}:{<del(VC)|Pl><SB>ien} $NDatPlSuff_0$

% Examen, Examens, Examina, Examina
$NNeut_s_en/ina_0$ = {<+NN><Neut>}:{}                    $NGenSgSuff_s$ | \
                     {<+NN><Neut>}:{<del(VC)|Pl>in<SB>a} $NDatPlSuff_0$

% Konto, Kontos, Konten, Konten
$NNeut_s_o/en_0$ = {<+NN><Neut>}:{}                   $NGenSgSuff_s$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Intermezzo, Intermezzos, Intermezzi, Intermezzi
$NNeut_s_o/i_0$ = {<+NN><Neut>}:{}                  $NGenSgSuff_s$ | \
                  {<+NN><Neut>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Oxymoron, Oxymorons, Oxymora, Oxymora
$NNeut_s_on/a_0$ = {<+NN><Neut>}:{}                  $NGenSgSuff_s$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>a} $NDatPlSuff_0$

% Stadion, Stadions, Stadien, Stadien
$NNeut_s_on/en_0$ = {<+NN><Neut>}:{}                   $NGenSgSuff_s$ | \
                    {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Aktivum, Aktivums, Aktiva, Aktiva
$NNeut_s_um/a_0$ = {<+NN><Neut>}:{}                  $NGenSgSuff_s$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>a} $NDatPlSuff_0$

% Museum, Museums, Museen, Museen
$NNeut_s_um/en_0$ = {<+NN><Neut>}:{}                   $NGenSgSuff_s$ | \
                    {<+NN><Neut>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Herz, Herzens, Herzen, Herzen
$NNeut_ens_en_0$ = {<+NN><Neut>}:{}       $NGenSgSuff_ens$ | \
                   {<+NN><Neut>}:{<SB>en} $NDatPlSuff_0$

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
$NNeut-Adj|Sg$ = {<+NN><Neut><Nom><Sg><St>}:{<SB>es} | \
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
$NFem|Sg_0$ = {<+NN><Fem>}:{} $NGenSgSuff_0$

% Anchorwomen, Anchorwomen (suppletive plural)
$NFem|Pl_0$ = {<+NN><Fem>}:{} $NDatPlSuff_0$

% Ananas, Ananas, Ananas, Ananas
$NFem_0_0_0$ = {<+NN><Fem>}:{} $NGenSgSuff_0$ | \
               {<+NN><Fem>}:{} $NDatPlSuff_0$

% Randale, Randale, Randale, Randalen
$NFem_0_0_n$ = {<+NN><Fem>}:{} $NGenSgSuff_0$ | \
               {<+NN><Fem>}:{} $NDatPlSuff_n$

% Mutter, Mutter, Mütter, Müttern
$NFem_0_\$_n$ = {<+NN><Fem>}:{}      $NGenSgSuff_0$ | \
                {<+NN><Fem>}:{<uml>} $NDatPlSuff_n$

% Drangsal, Drangsal, Drangsale, Drangsalen
$NFem_0_e_n$ = {<+NN><Fem>}:{}      $NGenSgSuff_0$ | \
               {<+NN><Fem>}:{<SB>e} $NDatPlSuff_n$

% Kenntnis, Kenntnis, Kenntnisse, Kenntnissen
$NFem_0_e_n~ss$ = $SS$ $NFem_0_e_n$

% Wand, Wand, Wände, Wänden
$NFem_0_\$e_n$ = {<+NN><Fem>}:{}           $NGenSgSuff_0$ | \
                 {<+NN><Fem>}:{<uml><SB>e} $NDatPlSuff_n$

% Frau, Frau, Frauen, Frauen; Arbeit, Arbeit, Arbeiten, Arbeiten
$NFem_0_en_0$ = {<+NN><Fem>}:{}       $NGenSgSuff_0$ | \
                {<+NN><Fem>}:{<SB>en} $NDatPlSuff_0$

% Werkstatt, Werkstatt, Werkstätten, Werkstätten
$NFem_0_\$en_0$ = {<+NN><Fem>}:{}            $NGenSgSuff_0$ | \
                  {<+NN><Fem>}:{<uml><SB>en} $NDatPlSuff_0$

% Hilfe, Hilfe, Hilfen, Hilfen; Tafel, Tafel, Tafeln, Tafeln
$NFem_0_n_0$ = {<+NN><Fem>}:{}      $NGenSgSuff_0$ | \
               {<+NN><Fem>}:{<SB>n} $NDatPlSuff_0$

% Smartwatch, Smartwatch, Smartwatches, Smartwatches
$NFem_0_es_0$ = {<+NN><Fem>}:{}       $NGenSgSuff_0$ | \
                {<+NN><Fem>}:{<SB>es} $NDatPlSuff_0$

% Oma, Oma, Omas, Omas
$NFem_0_s_0$ = {<+NN><Fem>}:{}      $NGenSgSuff_0$ | \
               {<+NN><Fem>}:{<SB>s} $NDatPlSuff_0$

% Algebra, Algebra, Algebren, Algebren; Firma, Firma, Firmen, Firmen
$NFem_0_a/en_0$ = {<+NN><Fem>}:{}                   $NGenSgSuff_0$ | \
                  {<+NN><Fem>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Phalanx, Phalanx, Phalangen, Phalangen
$NFem_0_anx/angen_0$ = {<+NN><Fem>}:{}                      $NGenSgSuff_0$ | \
                       {<+NN><Fem>}:{<del(VC)|Pl>ang<SB>en} $NDatPlSuff_0$

% Minestrone, Minestrone, Minestroni, Minestroni
$NFem_0_e/i_0$ = {<+NN><Fem>}:{}                  $NGenSgSuff_0$ | \
                 {<+NN><Fem>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Lex, Lex, Leges, Leges
$NFem_0_ex/eges_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>eg<SB>es} $NDatPlSuff_0$

% Basis, Basis, Basen, Basen
$NFem_0_is/en_0$ = {<+NN><Fem>}:{}                   $NGenSgSuff_0$ | \
                   {<+NN><Fem>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Neuritis, Neuritis, Neuritiden, Neuritiden
$NFem_0_is/iden_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>id<SB>en} $NDatPlSuff_0$

% Matrix, Matrix, Matrizen, Matrizen
$NFem_0_ix/izen_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>iz<SB>en} $NDatPlSuff_0$

% Radix, Radix, Radizes, Radizes
$NFem_0_ix/izes_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>iz<SB>es} $NDatPlSuff_0$

% Freundin, Freundin, Freundinnen
$NFem-in$ = {<+NN><Fem>}:{}        $NGenSgSuff_0$ | \
            {<+NN><Fem>}:{n<SB>en} $NDatPlSuff_0$

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

% Kosten, Kosten
$NNoGend|Pl_0$ = {<+NN><NoGend>}:{} $NDatPlSuff_0$

% Leute, Leuten
$NNoGend|Pl_n$ = {<+NN><NoGend>}:{} $NDatPlSuff_n$


% proper names

$NameMasc_0$ = {<+NPROP><Masc>}:{} $NGenSgSuff_0$

% Andreas, Andreas'
$NameMasc_apos$ = {<+NPROP><Masc>}:{} $NGenSgSuff_0$ | \
                  {<+NPROP><Masc><Gen><Sg>}:{<SB>’}

$NameMasc_es$ = {<+NPROP><Masc>}:{} $NGenSgSuff_es$

$NameMasc_s$ = {<+NPROP><Masc>}:{} $NGenSgSuff_s$

$NameNeut_0$ = {<+NPROP><Neut>}:{} $NGenSgSuff_0$

% Paris, Paris'
$NameNeut_apos$ = {<+NPROP><Neut>}:{} $NGenSgSuff_0$ | \
                  {<+NPROP><Neut><Gen><Sg>}:{<SB>’}

$NameNeut_es$ = {<+NPROP><Neut>}:{} $NGenSgSuff_es$

$NameNeut_s$ = {<+NPROP><Neut>}:{} $NGenSgSuff_s$

$NameFem_0$ = {<+NPROP><Fem>}:{} $NGenSgSuff_0$

% Felicitas, Felicitas'
$NameFem_apos$ = {<+NPROP><Fem>}:{} $NGenSgSuff_0$ | \
                 {<+NPROP><Fem><Gen><Sg>}:{<SB>’}

$NameFem_s$ = {<+NPROP><Fem>}:{} $NGenSgSuff_s$

$NameNoGend|Pl_0$ = {<+NPROP><NoGend>}:{} $NDatPlSuff_0$

$NameNoGend|Pl_n$ = {<+NPROP><NoGend>}:{} $NDatPlSuff_n$

% family names ending in -s, -z
$Name-Fam_0$ = {<+NPROP><NoGend>}:{}        $NGenSgSuff_0$ | \
               {<+NPROP><NoGend>}:{en<SB>s} $NDatPlSuff_0$

% family names
$Name-Fam_s$ = {<+NPROP><NoGend>}:{}      $NGenSgSuff_s$ | \
               {<+NPROP><NoGend>}:{<SB>s} $NDatPlSuff_0$


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

% dunkel
$AdjPos-el$ = {}:{<del(e)|ADJ>} $AdjPos$                  | \
              {<+ADJ><Pos>}:{} $AdjInflSuff-n$ {<Old>}:{} | \ % cf. Duden-Grammatik (2016: § 494)
              {<+ADJ><Pos>}:{} $AdjInflSuff-m$ {<Old>}:{}     % cf. Duden-Grammatik (2016: § 494)

% bitter
$AdjPos-er$ = $AdjPos$                                    | \
              {}:{<del(e)|ADJ>} $AdjPos$                  | \
              {<+ADJ><Pos>}:{} $AdjInflSuff-n$ {<Old>}:{} | \ % cf. Duden-Grammatik (2016: § 494)
              {<+ADJ><Pos>}:{} $AdjInflSuff-m$ {<Old>}:{}     % cf. Duden-Grammatik (2016: § 494)

% trocken
$AdjPos-en$ = $AdjPos$ | \
              {}:{<del(e)|ADJ>} $AdjPos$

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

% dunkler
$AdjComp-el$ = {}:{<del(e)|ADJ>} $AdjComp$

% bitt(e)rer
$AdjComp-er$ = $AdjComp$ | \
               {}:{<del(e)|ADJ>} $AdjComp$

% trock(e)ner
$AdjComp-en$ = $AdjComp-er$

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

% deutsch; [das] Deutsch
$Adj-Lang$ = $Adj_0$ | \
             $NNeut|Sg_s$


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

$DemSuff-solch|St$ = $DemSuff$

$DemSuff-solch|Wk$ = {[<Attr><Subst>]<Masc><Nom><Sg><Wk>}:{<SB>e}    | \
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

$DemSuff-solch$ = $DemSuff-solch|St$ | \
                  $DemSuff-solch|Wk$ | \ % cf. Duden-Grammatik (2016: § 432)
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

$WSuff-welch$ = $DemSuff-solch|St$ | \
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

$IndefSuff-irgendwelch$ = $DemSuff-solch|St$

$IndefSuff-all$ = $DemSuff-solch|St$                           | \
                  {<Subst><Masc><Dat><Sg><Wk><NonSt>}:{<SB>en} | \ % cf. Duden-Grammatik (2016: § 411)
                  {<Subst><Neut><Dat><Sg><Wk><NonSt>}:{<SB>en} | \ % cf. Duden-Grammatik (2016: § 411)
                  {<Attr><Invar>}:{}

$IndefSuff-jed|St$ = {[<Attr><Subst>]<Masc><Nom><Sg><St>}:{<SB>er} | \
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

$IndefSuff-jed|Wk$ = {[<Attr><Subst>]<Masc><Nom><Sg><Wk>}:{<SB>e}  | \
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

$IndefSuff-jed$ = $IndefSuff-jed|St$ | \
                  $IndefSuff-jed|Wk$

$IndefSuff-jeglich$ = $DemSuff$ | \
                      $IndefSuff-jed|Wk$

$IndefSuff-saemtlich$ = $DemSuff-solch|St$ | \
                        $DemSuff-solch|Wk$ | \
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

$IndefSuff-ein|St$ = $ArtIndefSubstSuff$

$IndefSuff-ein|Wk$ = {<Subst><Masc><Nom><Sg><Wk>}:{<SB>e}  | \
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

$IndefSuff-ein$ = $IndefSuff-ein|St$ | \
                  $IndefSuff-ein|Wk$

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

$PossSuff|St$ = $ArtNegSuff$

$PossSuff|Wk$ = {<Subst><Masc><Nom><Sg><Wk>}:{<SB>e}    | \
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

$PossSuff$ = $PossSuff|St$ | \
             $PossSuff|Wk$

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
$Poss|Wk$ = {<+POSS>}:{} $PossSuff|Wk$

% unserige/unsrige
$Poss|Wk-er$ = {<+POSS>}:{<del(e)|PRO>} $PossSuff|Wk$

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

$CardSuff-ein|St$ = $ArtIndefSuff$

$CardSuff-ein|Wk$ = {[<Attr><Subst>]<Masc><Nom><Sg><Wk>}:{<SB>e}  | \
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

$CardSuff-ein$ = $CardSuff-ein|St$ | \
                 $CardSuff-ein|Wk$

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

$VInfSuff_en$ = {<+V><Inf>}:{<SB>en} | \
                {<+V><Inf><zu>}:{<ins(zu)><SB>en}

$VInfSuff_n$ = {<+V><Inf>}:{<SB>n} | \
               {<+V><Inf><zu>}:{<ins(zu)><SB>n}

% gehen; sehen; laufen
$VInf$ = $VInfSuff_en$

% notwassern (cf. $SchwaTrigger$ in markers.fst)
$VInf-el-er$ = $VInfSuff_en$

% downcyclen
$VInf-len$ = $VInfSuff_n$

% tun
$VInf_n$ = $VInfSuff_n$

$VPPresSuff_end$ = {<+V><PPres>}:{<SB>end} | \
                   {<+V><PPres><zu>}:{<ins(zu)><SB>end}

$VPPresSuff_nd$ = {<+V><PPres>}:{<SB>nd} | \
                  {<+V><PPres><zu>}:{<ins(zu)><SB>nd}

% gehend; sehend; laufend
$VPPres$ = $VPPresSuff_end$

% notwassernd (cf. $SchwaTrigger$ in markers.fst)
$VPPres-el-er$ = $VPPresSuff_end$

% downcyclend
$VPPres-len$ = $VPPresSuff_nd$

$VPPastSuff_et$ =  {<+V><PPast>}:{<ins(ge)><SB><ins(e)>t}

$VPPastSuff_t$ =  {<+V><PPast>}:{<ins(ge)><SB>t}

$VPPastSuff_en$ = {<+V><PPast>}:{<ins(ge)><SB>en}

$VPPastSuff_n$ = {<+V><PPast>}:{<ins(ge)><SB>n}

$haben$ = {<haben>}:{}

$sein$ = {<sein>}:{}

% gehabt; gedacht
$VPPastWeak$ = $VPPastSuff_et$

$VPPastWeak+haben$ = $VPPastSuff_et$ $haben$

$VPPastWeak+sein$ = $VPPastSuff_et$ $sein$

% gegangen; gesehen; gelaufen
$VPPastStr$ = $VPPastSuff_en$

$VPPastStr+haben$ = $VPPastSuff_en$ $haben$

$VPPastStr+sein$ = $VPPastSuff_en$ $sein$

% gesandt; gewandt
$VPPast-d_t$ = $VPPastSuff_t$

$VPPast-d_t+haben$ = $VPPastSuff_t$ $haben$

$VPPast-d_t+sein$ = $VPPastSuff_t$ $sein$

% getan
$VPPast_n$ = $VPPastSuff_n$

$VPPast_n+haben$ = $VPPastSuff_n$ $haben$

$VPPast_n+sein$ = $VPPastSuff_n$ $sein$

% downgecyclet
$VPPast-len$ = $VPPastSuff_t$

$VPPast-len+haben$ = $VPPastSuff_t$ $haben$

$VPPast-len+sein$ = $VPPastSuff_t$ $sein$

$VPresInd1SgSuff_0$ = {<+V><1><Sg><Pres><Ind>}:{}

$VPresInd1SgNonStSuff_0$ = {<+V><1><Sg><Pres><Ind><NonSt>}:{} % cf. Duden-Grammatik (2016: § 622)

$VPresInd1SgSuff_e$ = {<+V><1><Sg><Pres><Ind>}:{<SB>e}

$VPresInd2SgSuff_st$ = {<+V><2><Sg><Pres><Ind>}:{<SB>st}

$VPresInd2SgSuff_est$ = {<+V><2><Sg><Pres><Ind>}:{<SB><ins(e)>st}

$VPresInd2SgSuff-s_est$ = {<+V><2><Sg><Pres><Ind>}:{<SB>st} | \
                          {<+V><2><Sg><Pres><Ind><Old>}:{<SB>est} % cf. Duden-Grammatik (2016: § 643)

$VPresInd3SgSuff_0$ = {<+V><3><Sg><Pres><Ind>}:{}

$VPresInd3SgSuff_et$ = {<+V><3><Sg><Pres><Ind>}:{<SB><ins(e)>t}

$VPresInd3SgSuff_t$ = {<+V><3><Sg><Pres><Ind>}:{<SB>t}

$VPresIndPlSuff$ = {<+V><1><Pl><Pres><Ind>}:{<SB>en}        | \
                   {<+V><2><Pl><Pres><Ind>}:{<SB><ins(e)>t} | \
                   {<+V><3><Pl><Pres><Ind>}:{<SB>en}

$VPresIndPlSuff-tun$ = {<+V><1><Pl><Pres><Ind>}:{<SB>n} | \
                       {<+V><2><Pl><Pres><Ind>}:{<SB>t} | \
                       {<+V><3><Pl><Pres><Ind>}:{<SB>n}

$VPresInd13PlSuff-sein$ = {<+V><1><Pl><Pres><Ind>}:{} | \
                          {<+V><3><Pl><Pres><Ind>}:{}

$VPresInd2PlSuff-sein$ = {<+V><2><Pl><Pres><Ind>}:{}

$VPresSubjSuff$ = {<+V><1><Sg><Pres><Subj>}:{<SB>e}   | \
                  {<+V><2><Sg><Pres><Subj>}:{<SB>est} | \
                  {<+V><3><Sg><Pres><Subj>}:{<SB>e}   | \
                  {<+V><1><Pl><Pres><Subj>}:{<SB>en}  | \
                  {<+V><2><Pl><Pres><Subj>}:{<SB>et}  | \
                  {<+V><3><Pl><Pres><Subj>}:{<SB>en}

$VPresSubjSuff-len$ = {<+V><1><Sg><Pres><Subj>}:{}       | \
                      {<+V><2><Sg><Pres><Subj>}:{<SB>st} | \
                      {<+V><3><Sg><Pres><Subj>}:{}       | \
                      {<+V><1><Pl><Pres><Subj>}:{<SB>n}  | \
                      {<+V><2><Pl><Pres><Subj>}:{<SB>t}  | \
                      {<+V><3><Pl><Pres><Subj>}:{<SB>n}

$VPresSubjSuff-sein$ = {<+V><1><Sg><Pres><Subj>}:{}        | \
                       {<+V><2><Sg><Pres><Subj>}:{<SB>est} | \
                       {<+V><2><Sg><Pres><Subj>}:{<SB>st}  | \
                       {<+V><3><Sg><Pres><Subj>}:{}        | \
                       {<+V><1><Pl><Pres><Subj>}:{<SB>en}  | \
                       {<+V><2><Pl><Pres><Subj>}:{<SB>et}  | \
                       {<+V><3><Pl><Pres><Subj>}:{<SB>en}

% geh(e), gehst, geht, gehen, geht, gehen
% denk(e), denkst, denkt, denken, denkt, denken
$VPres$ = $VPresInd1SgSuff_e$      | \
          $VPresInd1SgNonStSuff_0$ | \
          $VPresInd2SgSuff_est$    | \
          $VPresInd3SgSuff_et$     | \
          $VPresIndPlSuff$         | \
          $VPresSubjSuff$

% sende, sendest, sendet, senden, sendet, senden
$VPres-m-n$ = $VPresInd1SgSuff_e$   | \
              $VPresInd2SgSuff_est$ | \
              $VPresInd3SgSuff_et$  | \
              $VPresIndPlSuff$      | \
              $VPresSubjSuff$

% heiße, heiß(es)t, heißt, heißen, heißt, heißen
$VPres-s$ = $VPresInd1SgSuff_e$      | \
            $VPresInd1SgNonStSuff_0$ | \
            $VPresInd2SgSuff-s_est$  | \
            $VPresInd3SgSuff_et$     | \
            $VPresIndPlSuff$         | \
            $VPresSubjSuff$

% notwasser(e), notwasserst, notwassert, notwassern, notwassert, notwassern
% (cf. $SchwaTrigger$ in markers.fst)
$VPres-el-er$ = $VPres$

% downcycle, downcyclest, downcyclet, downcyclen, downcyclet, downcyclen
$VPres-len$ = $VPresInd1SgSuff_0$  | \
              $VPresInd2SgSuff_st$ | \
              $VPresInd3SgSuff_t$  | \
              $VPresIndPlSuff-tun$ | \
              $VPresSubjSuff-len$

% siehst, sieht
% läufst, läuft
% hast, hat
$VPresInd23Sg$ = $VPresInd2SgSuff_st$ | \
                 $VPresInd3SgSuff_et$

% hältst, hält
$VPresInd23Sg-t_0$ = $VPresInd2SgSuff_st$ | \
                     $VPresInd3SgSuff_0$

% lädst, lädt
$VPresInd23Sg-d_t$ = $VPresInd2SgSuff_st$ | \
                     $VPresInd3SgSuff_t$

% seh(e), sehen, seht, sehen
% lauf(e), laufen, lauft, laufen
% hab(e), haben, habt, haben
% halt(e), halten, haltet, halten
% lad(e), laden, ladet, laden
$VPresNonInd23Sg$ = $VPresInd1SgSuff_e$      | \
                    $VPresInd1SgNonStSuff_0$ | \
                    $VPresIndPlSuff$         | \
                    $VPresSubjSuff$

% tu(e), tust, tut, tun, tut, tun
$VPres-tun$ = $VPresInd1SgSuff_e$      | \
              $VPresInd1SgNonStSuff_0$ | \
              $VPresInd2SgSuff_est$    | \
              $VPresInd3SgSuff_et$     | \
              $VPresIndPlSuff-tun$     | \
              $VPresSubjSuff$

% wirst
$VPresInd2Sg-werden$ = $VPresInd2SgSuff_st$

% wird
$VPresInd3Sg-werden$ = $VPresInd3SgSuff_0$

% bin
$VPresInd1Sg-sein$ = $VPresInd1SgSuff_0$

% bist
$VPresInd2Sg-sein$ = $VPresInd2SgSuff_st$

% ist
$VPresInd3Sg-sein$ = $VPresInd3SgSuff_et$

% sind
$VPresInd13Pl-sein$ = $VPresInd13PlSuff-sein$

% seid
$VPresInd2Pl-sein$ = $VPresInd2PlSuff-sein$

% sei, sei(e)st, seien, seiet
$VPresSubj-sein$ = $VPresSubjSuff-sein$

% kann, kannst, kann
% weiß, weißt, weiß
$VModPresIndSg$ = $VPresInd1SgSuff_0$   | \
                  $VPresInd2SgSuff_est$ | \
                  $VPresInd3SgSuff_0$

% können, könnt, können
% wissen, wisst, wissen
$VModPresNonIndSg$ = $VPresIndPlSuff$ | \
                     $VPresSubjSuff$

$VPastIndWeakSuff_et$ = {<+V><1><Sg><Past><Ind>}:{<SB><ins(e)>t<SB>e}   | \
                        {<+V><2><Sg><Past><Ind>}:{<SB><ins(e)>t<SB>est} | \
                        {<+V><3><Sg><Past><Ind>}:{<SB><ins(e)>t<SB>e}   | \
                        {<+V><1><Pl><Past><Ind>}:{<SB><ins(e)>t<SB>en}  | \
                        {<+V><2><Pl><Past><Ind>}:{<SB><ins(e)>t<SB>et}  | \
                        {<+V><3><Pl><Past><Ind>}:{<SB><ins(e)>t<SB>en}

$VPastIndWeakSuff_t$ = {<+V><1><Sg><Past><Ind>}:{<SB>t<SB>e}   | \
                       {<+V><2><Sg><Past><Ind>}:{<SB>t<SB>est} | \
                       {<+V><3><Sg><Past><Ind>}:{<SB>t<SB>e}   | \
                       {<+V><1><Pl><Past><Ind>}:{<SB>t<SB>en}  | \
                       {<+V><2><Pl><Past><Ind>}:{<SB>t<SB>et}  | \
                       {<+V><3><Pl><Past><Ind>}:{<SB>t<SB>en}

$VPastIndStrSuff$ = {<+V><1><Sg><Past><Ind>}:{}               | \
                    {<+V><2><Sg><Past><Ind>}:{<SB><ins(e)>st} | \
                    {<+V><2><Sg><Past><Ind>}:{<SB>st}         | \ % cf. Duden-Grammatik (2016: § 642)
                    {<+V><3><Sg><Past><Ind>}:{}               | \
                    {<+V><1><Pl><Past><Ind>}:{<SB>en}         | \
                    {<+V><2><Pl><Past><Ind>}:{<SB><ins(e)>t}  | \
                    {<+V><3><Pl><Past><Ind>}:{<SB>en}

$VPastIndStrSuff-s$ = {<+V><1><Sg><Past><Ind>}:{}              | \
                      {<+V><2><Sg><Past><Ind>}:{<SB>st}        | \ % cf. Duden-Grammatik (2016: § 642)
                      {<+V><2><Sg><Past><Ind>}:{<SB>est}       | \ % cf. Duden-Grammatik (2016: § 643)
                      {<+V><3><Sg><Past><Ind>}:{}              | \
                      {<+V><1><Pl><Past><Ind>}:{<SB>en}        | \
                      {<+V><2><Pl><Past><Ind>}:{<SB>t}         | \
                      {<+V><2><Pl><Past><Ind><Old>}:{<SB>et}   | \ % cf. Duden-Grammatik (2016: § 643)
                      {<+V><3><Pl><Past><Ind>}:{<SB>en}

$VPastIndSgSuff-werden$ = {<+V><1><Sg><Past><Ind>}:{<SB>e}   | \
                          {<+V><2><Sg><Past><Ind>}:{<SB>est} | \
                          {<+V><3><Sg><Past><Ind>}:{<SB>e}

$VPastIndSgSuff-ward$ = {<+V><1><Sg><Past><Ind><Old>}:{}       | \
                        {<+V><2><Sg><Past><Ind><Old>}:{<SB>st} | \
                        {<+V><3><Sg><Past><Ind><Old>}:{}

$VPastIndPlSuff-werden$ = {<+V><1><Pl><Past><Ind>}:{<SB>en}  | \
                          {<+V><2><Pl><Past><Ind>}:{<SB>et}  | \
                          {<+V><3><Pl><Past><Ind>}:{<SB>en}

$VPastSubjWeakSuff$ = {<+V><1><Sg><Past><Subj>}:{<SB><ins(e)>t<SB>e}   | \
                      {<+V><2><Sg><Past><Subj>}:{<SB><ins(e)>t<SB>est} | \
                      {<+V><3><Sg><Past><Subj>}:{<SB><ins(e)>t<SB>e}   | \
                      {<+V><1><Pl><Past><Subj>}:{<SB><ins(e)>t<SB>en}  | \
                      {<+V><2><Pl><Past><Subj>}:{<SB><ins(e)>t<SB>et}  | \
                      {<+V><3><Pl><Past><Subj>}:{<SB><ins(e)>t<SB>en}

$VPastSubjWeakSuff_t$ = {<+V><1><Sg><Past><Subj>}:{<SB>t<SB>e}   | \
                        {<+V><2><Sg><Past><Subj>}:{<SB>t<SB>est} | \
                        {<+V><3><Sg><Past><Subj>}:{<SB>t<SB>e}   | \
                        {<+V><1><Pl><Past><Subj>}:{<SB>t<SB>en}  | \
                        {<+V><2><Pl><Past><Subj>}:{<SB>t<SB>et}  | \
                        {<+V><3><Pl><Past><Subj>}:{<SB>t<SB>en}

$VPastSubjStrSuff$ = {<+V><1><Sg><Past><Subj>}:{<SB>e}   | \
                     {<+V><2><Sg><Past><Subj>}:{<SB>est} | \
                     {<+V><3><Sg><Past><Subj>}:{<SB>e}   | \
                     {<+V><1><Pl><Past><Subj>}:{<SB>en}  | \
                     {<+V><2><Pl><Past><Subj>}:{<SB>et}  | \
                     {<+V><3><Pl><Past><Subj>}:{<SB>en}

$VPastSubj2Suff-sein$ = {<+V><2><Sg><Past><Subj>}:{<SB>st} | \
                        {<+V><2><Pl><Past><Subj>}:{<SB>t}

$VPastWeak$ = $VPastIndWeakSuff_et$ | \
              $VPastSubjWeakSuff$

$VPast-len$ = $VPastIndWeakSuff_t$ | \
              $VPastSubjWeakSuff_t$

% dachte, dachtest, dachte, dachten, dachtet, dachten
% konnte, konntest, konnte, konnten, konntet, konnten
% wusste, wusstest, wusste, wussten, wusstet, wussten
$VPastIndWeak$ = $VPastIndWeakSuff_et$

% hatte, hattest, hatte, hatten, hattet, hatten
% sandte, sandtest, sandte, sandten, sandtet, sandten
$VPastInd-d-t_t$ = $VPastIndWeakSuff_t$

% downcyclete, downcycletest, downcyclete, downcycleten, downcycletet, downcycleten
$VPastInd-len$ = $VPastIndWeakSuff_t$

% sah, sahst, sah, sahen, saht, sahen
% fand, fand(e)st, fand, fanden, fandet, fanden
$VPastIndStr$ = $VPastIndStrSuff$

% las, las(es)t, las, lasen, last, lasen
$VPastIndStr-s$ = $VPastIndStrSuff-s$

% wurde, wurdest, wurde, wurden, wurdet, wurden
$VPastInd-werden$ = $VPastIndSgSuff-werden$ | \
                    $VPastIndPlSuff-werden$

% ward, wardst, ward
$VPastIndSg-ward$ = $VPastIndSgSuff-ward$

% wurden, wurdet, wurden
$VPastIndPl-werden$ = $VPastIndPlSuff-werden$

% dächte, dächtest, dächte, dächten, dächtet, dächten
% könnte, könntest, könnte, könnten, könntet, könnten
% wüsste, wüsstest, wüsste, wüssten, wüsstet, wüssten
$VPastSubjWeak$ = $VPastSubjWeakSuff$

% downcyclete, downcycletest, downcyclete, downcycleten, downcycletet, downcycleten
$VPastSubj-len$ = $VPastSubjWeakSuff_t$

% sähe, sähest, sähe, sähen, sähet, sähen
% täte, tätest, täte, täten, tätet, täten
% würde, würdest, würde, würden, würdet, würden
$VPastSubjStr$ = $VPastSubjStrSuff$

% schwömme, schwömmest, schwömme, schwömmen, schwömmet, schwömmen
$VPastSubjOld$ = $VPastSubjStr$ {<Old>}:{}

% hätte, hättest, hätte, hätten, hättet, hätten
$VPastSubj-haben$ = $VPastSubjWeakSuff_t$

% wärst, wärt
$VPastSubj2-sein$ = $VPastSubj2Suff-sein$

% ging, gingst, ging, gingen, gingt, gingen
% lief, liefst, lief, liefen, lieft, liefen
$VPastStr$ = $VPastIndStr$ | \
             $VPastSubjStr$

% hieß, hieß(es)t, hieß, hießen, hießt, hießen
$VPastStr-s$ = $VPastIndStr-s$ | \
               $VPastSubjStr$

$VImpSgSuff_0$ = {<+V><Imp><Sg>}:{<rm|Imp>}

$VImpSgNonStSuff_0$ = {<+V><Imp><Sg><NonSt>}:{<rm|Imp>} % cf. Duden-Grammatik (2016: § 609)

$VImpSgSuff_e$ = {<+V><Imp><Sg>}:{<SB>e<rm|Imp>}

$VImpPlSuff_t$ = {<+V><Imp><Pl>}:{<SB><ins(e)>t<rm|Imp>}

$VImpPlSuff-sein$ = {<+V><Imp><Pl>}:{<rm|Imp>}

% sieh(e)
$VImpSg$ = $VImpSgSuff_0$ | \
           $VImpSgSuff_e$

% tu; sei
$VImpSg0$ = $VImpSgSuff_0$

$VImpSg-d-t$ = $VImpSgNonStSuff_0$ | \
               $VImpSgSuff_e$

$VImpSg-m-n$ = $VImpSgSuff_e$

$VImpSg-len$ = $VImpSgSuff_0$

% seht; tut
$VImpPl$ = $VImpPlSuff_t$

% seid
$VImpPl-sein$ = $VImpPlSuff-sein$

% geh(e), geht
% hab(e), habt
$VImp$ = $VImpSg$ | \
         $VImpPl$

% werd(e), werdet
$VImp-d-t$ = $VImpSg-d-t$ | \
             $VImpPl$

% kopfrechne, kopfrechnet
$VImp-m-n$ = $VImpSg-m-n$ | \
             $VImpPl$

% notwasser(e), notwassert (cf. $SchwaTrigger$ in markers.fst)
$VImp-el-er$ = $VImpSg-d-t$ | \
               $VImpPl$

% downcycle, downcyclet
$VImp-len$ = $VImpSg-len$ | \
             $VImpPl$

% lieben; spielen
$VWeak$ = $VInf$       | \
          $VPPres$     | \
          $VPPastWeak$ | \
          $VPres$      | \
          $VPastWeak$  | \
          $VImp$

$VWeak+haben$ = $VInf$             | \
                $VPPres$           | \
                $VPPastWeak+haben$ | \
                $VPres$            | \
                $VPastWeak$        | \
                $VImp$

$VWeak+sein$ = $VInf$            | \
               $VPPres$          | \
               $VPPastWeak+sein$ | \
               $VPres$           | \
               $VPastWeak$       | \
               $VImp$

% arbeiten; reden
$VWeak-d-t$ = $VInf$       | \
              $VPPres$     | \
              $VPPastWeak$ | \
              $VPres$      | \
              $VPastWeak$  | \
              $VImp-d-t$

$VWeak-d-t+haben$ = $VInf$             | \
                    $VPPres$           | \
                    $VPPastWeak+haben$ | \
                    $VPres$            | \
                    $VPastWeak$        | \
                    $VImp-d-t$

$VWeak-d-t+sein$ = $VInf$            | \
                   $VPPres$          | \
                   $VPPastWeak+sein$ | \
                   $VPres$           | \
                   $VPastWeak$       | \
                   $VImp-d-t$

% atmen; rechnen
$VWeak-m-n$ = $VInf$       | \
              $VPPres$     | \
              $VPPastWeak$ | \
              $VPres-m-n$  | \
              $VPastWeak$  | \
              $VImp-m-n$

$VWeak-m-n+haben$ = $VInf$             | \
                    $VPPres$           | \
                    $VPPastWeak+haben$ | \
                    $VPres-m-n$        | \
                    $VPastWeak$        | \
                    $VImp-m-n$

$VWeak-m-n+sein$ = $VInf$            | \
                   $VPPres$          | \
                   $VPPastWeak+sein$ | \
                   $VPres-m-n$       | \
                   $VPastWeak$       | \
                   $VImp-m-n$

% küssen
$VWeak-s$ = $VInf$       | \
            $VPPres$     | \
            $VPPastWeak$ | \
            $VPres-s$    | \
            $VPastWeak$  | \
            $VImp$

$VWeak-s+haben$ = $VInf$             | \
                  $VPPres$           | \
                  $VPPastWeak+haben$ | \
                  $VPres-s$          | \
                  $VPastWeak$        | \
                  $VImp$

$VWeak-s+sein$ = $VInf$            | \
                 $VPPres$          | \
                 $VPPastWeak+sein$ | \
                 $VPres-s$         | \
                 $VPastWeak$       | \
                 $VImp$

% segeln; rudern (cf. $SchwaTrigger$ in markers.fst)
$VWeak-el-er$ = $VInf-el-er$   | \
                $VPPres-el-er$ | \
                $VPPastWeak$   | \
                $VPres-el-er$  | \
                $VPastWeak$    | \
                $VImp-el-er$

$VWeak-el-er+haben$ = $VInf-el-er$       | \
                      $VPPres-el-er$     | \
                      $VPPastWeak+haben$ | \
                      $VPres-el-er$      | \
                      $VPastWeak$        | \
                      $VImp-el-er$

$VWeak-el-er+sein$ = $VInf-el-er$      | \
                     $VPPres-el-er$    | \
                     $VPPastWeak+sein$ | \
                     $VPres-el-er$     | \
                     $VPastWeak$       | \
                     $VImp-el-er$

% recyclen
$VWeak-len$ = $VInf-len$       | \
              $VPPres-len$     | \
              $VPPast-len$ | \
              $VPres-len$  | \
              $VPast-len$  | \
              $VImp-len$

$VWeak-len+haben$ = $VInf-len$             | \
                    $VPPres-len$           | \
                    $VPPast-len+haben$ | \
                    $VPres-len$        | \
                    $VPast-len$        | \
                    $VImp-len$

$VWeak-len+sein$ = $VInf-len$            | \
                   $VPPres-len$          | \
                   $VPPast-len+sein$ | \
                   $VPres-len$       | \
                   $VPast-len$       | \
                   $VImp-len$


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

$INFL$ = <>:<AbbrAdj>                $AbbrAdj$                | \
         <>:<AbbrNFem>               $AbbrNFem$               | \
         <>:<AbbrNMasc>              $AbbrNMasc$              | \
         <>:<AbbrNNeut>              $AbbrNNeut$              | \
         <>:<AbbrNNoGend>            $AbbrNNoGend$            | \
         <>:<AbbrPoss>               $AbbrPoss$               | \
         <>:<AbbrVImp>               $AbbrVImp$               | \
         <>:<Adj-Lang>               $Adj-Lang$               | \
         <>:<Adj_$>                  $Adj_\$$                 | \
         <>:<Adj_$e>                 $Adj_\$e$                | \
         <>:<Adj_0>                  $Adj_0$                  | \
         <>:<Adj_e>                  $Adj_e$                  | \
         <>:<AdjComp>                $AdjComp$                | \
         <>:<AdjComp-el>             $AdjComp-el$             | \
         <>:<AdjComp-en>             $AdjComp-en$             | \
         <>:<AdjComp-er>             $AdjComp-er$             | \
         <>:<AdjComp0-mehr>          $AdjComp0-mehr$          | \
         <>:<AdjPos>                 $AdjPos$                 | \
         <>:<AdjPos-el>              $AdjPos-el$              | \
         <>:<AdjPos-en>              $AdjPos-en$              | \
         <>:<AdjPos-er>              $AdjPos-er$              | \
         <>:<AdjPos0>                $AdjPos0$                | \
         <>:<AdjPos0-viel>           $AdjPos0-viel$           | \
         <>:<AdjPos0Attr>            $AdjPos0Attr$            | \
         <>:<AdjPos0AttrSubst>       $AdjPos0AttrSubst$       | \
         <>:<AdjPosAttr>             $AdjPosAttr$             | \
         <>:<AdjPosAttr-er>          $AdjPosAttr-er$          | \
         <>:<AdjPosPred>             $AdjPosPred$             | \
         <>:<AdjSup>                 $AdjSup$                 | \
         <>:<AdjSup-aller>           $AdjSup-aller$           | \
         <>:<AdjSupAttr>             $AdjSupAttr$             | \
         <>:<Adv>                    $Adv$                    | \
         <>:<AdvComp>                $AdvComp$                | \
         <>:<AdvComp0>               $AdvComp0$               | \
         <>:<AdvSup>                 $AdvSup$                 | \
         <>:<ArtDef>                 $ArtDef$                 | \
         <>:<ArtDef-das+DemNeut>     $ArtDef-das+DemNeut$     | \
         <>:<ArtDef-dem+DemMasc>     $ArtDef-dem+DemMasc$     | \
         <>:<ArtDef-dem+DemNeut>     $ArtDef-dem+DemNeut$     | \
         <>:<ArtDef-den+DemMasc>     $ArtDef-den+DemMasc$     | \
         <>:<ArtDef-den+DemNoGend>   $ArtDef-den+DemNoGend$   | \
         <>:<ArtDef-der+DemFem>      $ArtDef-der+DemFem$      | \
         <>:<ArtDef-der+DemMasc>     $ArtDef-der+DemMasc$     | \
         <>:<ArtDef-der+DemNoGend>   $ArtDef-der+DemNoGend$   | \
         <>:<ArtDef-des+DemMasc>     $ArtDef-des+DemMasc$     | \
         <>:<ArtDef-des+DemNeut>     $ArtDef-des+DemNeut$     | \
         <>:<ArtDef-die+DemFem>      $ArtDef-die+DemFem$      | \
         <>:<ArtDef-die+DemNoGend>   $ArtDef-die+DemNoGend$   | \
         <>:<ArtIndef>               $ArtIndef$               | \
         <>:<ArtIndef-n>             $ArtIndef-n$             | \
         <>:<ArtNeg>                 $ArtNeg$                 | \
         <>:<Card0>                  $Card0$                  | \
         <>:<Card-ein>               $Card-ein$               | \
         <>:<Card-kein>              $Card-kein$              | \
         <>:<Card-sieben>            $Card-sieben$            | \
         <>:<Card-vier>              $Card-vier$              | \
         <>:<Card-zwei>              $Card-zwei$              | \
         <>:<ConjCompar>             $ConjCompar$             | \
         <>:<ConjCoord>              $ConjCoord$              | \
         <>:<ConjInf>                $ConjInf$                | \
         <>:<ConjSub>                $ConjSub$                | \
         <>:<Dem>                    $Dem$                    | \
         <>:<Dem0>                   $Dem0$                   | \
         <>:<Dem-alldem>             $Dem-alldem$             | \
         <>:<Dem-dies>               $Dem-dies$               | \
         <>:<Dem-solch>              $Dem-solch$              | \
         <>:<DemDef>                 $DemDef$                 | \
         <>:<DigCard>                $DigCard$                | \
         <>:<DigFrac>                $DigFrac$                | \
         <>:<DigOrd>                 $DigOrd$                 | \
         <>:<Frac0>                  $Frac0$                  | \
         <>:<Indef0>                 $Indef0$                 | \
         <>:<Indef-all>              $Indef-all$              | \
         <>:<Indef-beid>             $Indef-beid$             | \
         <>:<Indef-ein>              $Indef-ein$              | \
         <>:<Indef-einig>            $Indef-einig$            | \
         <>:<Indef-irgendein>        $Indef-irgendein$        | \
         <>:<Indef-irgendwelch>      $Indef-irgendwelch$      | \
         <>:<Indef-jed>              $Indef-jed$              | \
         <>:<Indef-jeglich>          $Indef-jeglich$          | \
         <>:<Indef-kein>             $Indef-kein$             | \
         <>:<Indef-manch>            $Indef-manch$            | \
         <>:<Indef-mehrer>           $Indef-mehrer$           | \
         <>:<Indef-saemtlich>        $Indef-saemtlich$        | \
         <>:<Indef-welch>            $Indef-welch$            | \
         <>:<IPro-frau>              $IPro-frau$              | \
         <>:<IPro-jedefrau>          $IPro-jedefrau$          | \
         <>:<IPro-jederfrau>         $IPro-jederfrau$         | \
         <>:<IPro-jedermann>         $IPro-jedermann$         | \
         <>:<IPro-man>               $IPro-man$               | \
         <>:<IPro-unsereiner>        $IPro-unsereiner$        | \
         <>:<IPro-unsereins>         $IPro-unsereins$         | \
         <>:<IProMasc>               $IProMasc$               | \
         <>:<IProMascAccSg>          $IProMascAccSg$          | \
         <>:<IProMascDatSg>          $IProMascDatSg$          | \
         <>:<IProMascGenSg>          $IProMascGenSg$          | \
         <>:<IProMascNomSg>          $IProMascNomSg$          | \
         <>:<IProNeut>               $IProNeut$               | \
         <>:<IProNeutAccSg>          $IProNeutAccSg$          | \
         <>:<IProNeutDatSg>          $IProNeutDatSg$          | \
         <>:<IProNeutGenSg>          $IProNeutGenSg$          | \
         <>:<IProNeutNomSg>          $IProNeutNomSg$          | \
         <>:<Intj>                   $Intj$                   | \
         <>:<Name-Fam_0>             $Name-Fam_0$             | \
         <>:<Name-Fam_s>             $Name-Fam_s$             | \
         <>:<NameFem_0>              $NameFem_0$              | \
         <>:<NameFem_apos>           $NameFem_apos$           | \
         <>:<NameFem_s>              $NameFem_s$              | \
         <>:<NameMasc_0>             $NameMasc_0$             | \
         <>:<NameMasc_apos>          $NameMasc_apos$          | \
         <>:<NameMasc_es>            $NameMasc_es$            | \
         <>:<NameMasc_s>             $NameMasc_s$             | \
         <>:<NameNeut_0>             $NameNeut_0$             | \
         <>:<NameNeut_apos>          $NameNeut_apos$          | \
         <>:<NameNeut_es>            $NameNeut_es$            | \
         <>:<NameNeut_s>             $NameNeut_s$             | \
         <>:<NameNoGend|Pl_0>        $NameNoGend|Pl_0$        | \
         <>:<NameNoGend|Pl_n>        $NameNoGend|Pl_n$        | \
         <>:<NFem-Adj>               $NFem-Adj$               | \
         <>:<NFem-in>                $NFem-in$                | \
         <>:<NFem|Pl_0>              $NFem|Pl_0$              | \
         <>:<NFem|Sg_0>              $NFem|Sg_0$              | \
         <>:<NFem_0_$_n>             $NFem_0_\$_n$            | \
         <>:<NFem_0_$e_n>            $NFem_0_\$e_n$           | \
         <>:<NFem_0_$en_0>           $NFem_0_\$en_0$          | \
         <>:<NFem_0_0_0>             $NFem_0_0_0$             | \
         <>:<NFem_0_0_n>             $NFem_0_0_n$             | \
         <>:<NFem_0_a/en_0>          $NFem_0_a/en_0$          | \
         <>:<NFem_0_e_n>             $NFem_0_e_n$             | \
         <>:<NFem_0_e_n~ss>          $NFem_0_e_n~ss$          | \
         <>:<NFem_0_anx/angen_0>     $NFem_0_anx/angen_0$     | \
         <>:<NFem_0_e/i_0>           $NFem_0_e/i_0$           | \
         <>:<NFem_0_en_0>            $NFem_0_en_0$            | \
         <>:<NFem_0_es_0>            $NFem_0_es_0$            | \
         <>:<NFem_0_ex/eges_0>       $NFem_0_ex/eges_0$       | \
         <>:<NFem_0_is/en_0>         $NFem_0_is/en_0$         | \
         <>:<NFem_0_is/iden_0>       $NFem_0_is/iden_0$       | \
         <>:<NFem_0_ix/izen_0>       $NFem_0_ix/izen_0$       | \
         <>:<NFem_0_ix/izes_0>       $NFem_0_ix/izes_0$       | \
         <>:<NFem_0_n_0>             $NFem_0_n_0$             | \
         <>:<NFem_0_s_0>             $NFem_0_s_0$             | \
         <>:<NMasc-Adj>              $NMasc-Adj$              | \
         <>:<NMasc|Pl_0>             $NMasc|Pl_0$             | \
         <>:<NMasc|Sg_0>             $NMasc|Sg_0$             | \
         <>:<NMasc|Sg_es>            $NMasc|Sg_es$            | \
         <>:<NMasc|Sg_ns>            $NMasc|Sg_ns$            | \
         <>:<NMasc|Sg_s>             $NMasc|Sg_s$             | \
         <>:<NMasc_0_$e_n>           $NMasc_0_\$e_n$          | \
         <>:<NMasc_0_0_0>            $NMasc_0_0_0$            | \
         <>:<NMasc_0_0_n>            $NMasc_0_0_n$            | \
         <>:<NMasc_0_as/anten_0>     $NMasc_0_as/anten_0$     | \
         <>:<NMasc_0_e_n>            $NMasc_0_e_n$            | \
         <>:<NMasc_0_e_n~ss>         $NMasc_0_e_n~ss$         | \
         <>:<NMasc_0_e/i_0>          $NMasc_0_e/i_0$          | \
         <>:<NMasc_0_en_0>           $NMasc_0_en_0$           | \
         <>:<NMasc_0_es_0>           $NMasc_0_es_0$           | \
         <>:<NMasc_0_ex/izes_0>      $NMasc_0_ex/izes_0$      | \
         <>:<NMasc_0_nen_0>          $NMasc_0_nen_0$          | \
         <>:<NMasc_0_o/en_0>         $NMasc_0_o/en_0$         | \
         <>:<NMasc_0_o/i_0>          $NMasc_0_o/i_0$          | \
         <>:<NMasc_0_os/oden_0>      $NMasc_0_os/oden_0$      | \
         <>:<NMasc_0_os/oen_0>       $NMasc_0_os/oen_0$       | \
         <>:<NMasc_0_os/oi_0>        $NMasc_0_os/oi_0$        | \
         <>:<NMasc_0_s_0>            $NMasc_0_s_0$            | \
         <>:<NMasc_0_us/e_n>         $NMasc_0_us/e_n$         | \
         <>:<NMasc_0_us/een_0>       $NMasc_0_us/een_0$       | \
         <>:<NMasc_0_us/en_0>        $NMasc_0_us/en_0$        | \
         <>:<NMasc_0_us/i_0>         $NMasc_0_us/i_0$         | \
         <>:<NMasc_0_us/ier_n>       $NMasc_0_us/ier_n$       | \
         <>:<NMasc_0_ynx/yngen_0>    $NMasc_0_ynx/yngen_0$    | \
         <>:<NMasc_en_en_0>          $NMasc_en_en_0$          | \
         <>:<NMasc_es_$e_n>          $NMasc_es_\$e_n$         | \
         <>:<NMasc_es_$er_n>         $NMasc_es_\$er_n$        | \
         <>:<NMasc_es_as/anten_0~ss> $NMasc_es_as/anten_0~ss$ | \
         <>:<NMasc_es_e_n>           $NMasc_es_e_n$           | \
         <>:<NMasc_es_e_n~ss>        $NMasc_es_e_n~ss$        | \
         <>:<NMasc_es_en_0>          $NMasc_es_en_0$          | \
         <>:<NMasc_es_er_n>          $NMasc_es_er_n$          | \
         <>:<NMasc_es_es_0>          $NMasc_es_es_0$          | \
         <>:<NMasc_es_s_0>           $NMasc_es_s_0$           | \
         <>:<NMasc_es_ex/izes_0>     $NMasc_es_ex/izes_0$     | \
         <>:<NMasc_es_us/een_0~ss>   $NMasc_es_us/een_0~ss$   | \
         <>:<NMasc_es_us/en_0~ss>    $NMasc_es_us/en_0~ss$    | \
         <>:<NMasc_es_us/i_0~ss>     $NMasc_es_us/i_0~ss$     | \
         <>:<NMasc_n_n_0>            $NMasc_n_n_0$            | \
         <>:<NMasc_ns_n_0>           $NMasc_ns_n_0$           | \
         <>:<NMasc_ns_$n_0>          $NMasc_ns_\$n_0$         | \
         <>:<NMasc_s_$_n>            $NMasc_s_\$_n$           | \
         <>:<NMasc_s_$e_n>           $NMasc_s_\$e_n$          | \
         <>:<NMasc_s_$er_n>          $NMasc_s_\$er_n$         | \
         <>:<NMasc_s_$_0>            $NMasc_s_\$_0$           | \
         <>:<NMasc_s_0_0>            $NMasc_s_0_0$            | \
         <>:<NMasc_s_0_n>            $NMasc_s_0_n$            | \
         <>:<NMasc_s_e_n>            $NMasc_s_e_n$            | \
         <>:<NMasc_s_e/i_0>          $NMasc_s_e/i_0$          | \
         <>:<NMasc_s_en_0>           $NMasc_s_en_0$           | \
         <>:<NMasc_s_er_n>           $NMasc_s_er_n$           | \
         <>:<NMasc_s_es_0>           $NMasc_s_es_0$           | \
         <>:<NMasc_s_n_0>            $NMasc_s_n_0$            | \
         <>:<NMasc_s_nen_0>          $NMasc_s_nen_0$          | \
         <>:<NMasc_s_o/en_0>         $NMasc_s_o/en_0$         | \
         <>:<NMasc_s_o/i_0>          $NMasc_s_o/i_0$          | \
         <>:<NMasc_s_s_0>            $NMasc_s_s_0$            | \
         <>:<NNeut-Adj>              $NNeut-Adj$              | \
         <>:<NNeut-Adj|Sg>           $NNeut-Adj|Sg$           | \
         <>:<NNeut-Inner>            $NNeut-Inner$            | \
         <>:<NNeut|Pl_0>             $NNeut|Pl_0$             | \
         <>:<NNeut|Pl_n>             $NNeut|Pl_n$             | \
         <>:<NNeut|Sg_0>             $NNeut|Sg_0$             | \
         <>:<NNeut|Sg_es>            $NNeut|Sg_es$            | \
         <>:<NNeut|Sg_es~ss>         $NNeut|Sg_es~ss$         | \
         <>:<NNeut|Sg_s>             $NNeut|Sg_s$             | \
         <>:<NNeut_0_0_0>            $NNeut_0_0_0$            | \
         <>:<NNeut_0_0_n>            $NNeut_0_0_n$            | \
         <>:<NNeut_0_a/ata_0>        $NNeut_0_a/ata_0$        | \
         <>:<NNeut_0_a/en_0>         $NNeut_0_a/en_0$         | \
         <>:<NNeut_0_ans/antien_0>   $NNeut_0_ans/antien_0$   | \
         <>:<NNeut_0_ans/anzien_0>   $NNeut_0_ans/anzien_0$   | \
         <>:<NNeut_0_e_n>            $NNeut_0_e_n$            | \
         <>:<NNeut_0_e_n~ss>         $NNeut_0_e_n~ss$         | \
         <>:<NNeut_0_e/i_0>          $NNeut_0_e/i_0$          | \
         <>:<NNeut_0_e/ia_0>         $NNeut_0_e/ia_0$         | \
         <>:<NNeut_0_e/ien_0>        $NNeut_0_e/ien_0$        | \
         <>:<NNeut_0_en_0>           $NNeut_0_en_0$           | \
         <>:<NNeut_0_en/ina_0>       $NNeut_0_en/ina_0$       | \
         <>:<NNeut_0_ens/enzien_0>   $NNeut_0_ens/enzien_0$   | \
         <>:<NNeut_0_es_0>           $NNeut_0_es_0$           | \
         <>:<NNeut_0_nen_0>          $NNeut_0_nen_0$          | \
         <>:<NNeut_0_o/en_0>         $NNeut_0_o/en_0$         | \
         <>:<NNeut_0_o/i_0>          $NNeut_0_o/i_0$          | \
         <>:<NNeut_0_on/a_0>         $NNeut_0_on/a_0$         | \
         <>:<NNeut_0_on/en_0>        $NNeut_0_on/en_0$        | \
         <>:<NNeut_0_s_0>            $NNeut_0_s_0$            | \
         <>:<NNeut_0_um/a_0>         $NNeut_0_um/a_0$         | \
         <>:<NNeut_0_um/en_0>        $NNeut_0_um/en_0$        | \
         <>:<NNeut_0_us/en_0>        $NNeut_0_us/en_0$        | \
         <>:<NNeut_0_us/era_0>       $NNeut_0_us/era_0$       | \
         <>:<NNeut_0_us/ora_0>       $NNeut_0_us/ora_0$       | \
         <>:<NNeut_ens_en_0>         $NNeut_ens_en_0$         | \
         <>:<NNeut_es_$e_n>          $NNeut_es_\$e_n$         | \
         <>:<NNeut_es_$er_n>         $NNeut_es_\$er_n$        | \
         <>:<NNeut_es_e_n>           $NNeut_es_e_n$           | \
         <>:<NNeut_es_e_n~ss>        $NNeut_es_e_n~ss$        | \
         <>:<NNeut_es_en_0>          $NNeut_es_en_0$          | \
         <>:<NNeut_es_er_n>          $NNeut_es_er_n$          | \
         <>:<NNeut_es_es_0>          $NNeut_es_es_0$          | \
         <>:<NNeut_es_ien_0>         $NNeut_es_ien_0$         | \
         <>:<NNeut_es_s_0>           $NNeut_es_s_0$           | \
         <>:<NNeut_s_$_n>            $NNeut_s_\$_n$           | \
         <>:<NNeut_s_$er_n>          $NNeut_s_\$er_n$         | \
         <>:<NNeut_s_0_n>            $NNeut_s_0_n$            | \
         <>:<NNeut_s_a_0>            $NNeut_s_a_0$            | \
         <>:<NNeut_s_a/ata_0>        $NNeut_s_a/ata_0$        | \
         <>:<NNeut_s_a/en_0>         $NNeut_s_a/en_0$         | \
         <>:<NNeut_s_e_n>            $NNeut_s_e_n$            | \
         <>:<NNeut_s_e/i_0>          $NNeut_s_e/i_0$          | \
         <>:<NNeut_s_e/ia_0>         $NNeut_s_e/ia_0$         | \
         <>:<NNeut_s_e/ien_0>        $NNeut_s_e/ien_0$        | \
         <>:<NNeut_s_en_0>           $NNeut_s_en_0$           | \
         <>:<NNeut_s_en/ina_0>       $NNeut_s_en/ina_0$       | \
         <>:<NNeut_s_ien_0>          $NNeut_s_ien_0$          | \
         <>:<NNeut_s_n_0>            $NNeut_s_n_0$            | \
         <>:<NNeut_s_nen_0>          $NNeut_s_nen_0$          | \
         <>:<NNeut_s_o/en_0>         $NNeut_s_o/en_0$         | \
         <>:<NNeut_s_o/i_0>          $NNeut_s_o/i_0$          | \
         <>:<NNeut_s_on/a_0>         $NNeut_s_on/a_0$         | \
         <>:<NNeut_s_on/en_0>        $NNeut_s_on/en_0$        | \
         <>:<NNeut_s_s_0>            $NNeut_s_s_0$            | \
         <>:<NNeut_s_um/a_0>         $NNeut_s_um/a_0$         | \
         <>:<NNeut_s_um/en_0>        $NNeut_s_um/en_0$        | \
         <>:<NNeut_s_0_0>            $NNeut_s_0_0$            | \
         <>:<NNoGend|Pl_0>           $NNoGend|Pl_0$           | \
         <>:<NNoGend|Pl_n>           $NNoGend|Pl_n$           | \
         <>:<Ord>                    $Ord$                    | \
         <>:<PIndInvar>              $PIndInvar$              | \
         <>:<Poss>                   $Poss$                   | \
         <>:<Poss-er>                $Poss-er$                | \
         <>:<Poss|Wk>                $Poss|Wk$                | \
         <>:<Poss|Wk-er>             $Poss|Wk-er$             | \
         <>:<Postp>                  $Postp$                  | \
         <>:<PPro1AccPl>             $PPro1AccPl$             | \
         <>:<PPro1AccSg>             $PPro1AccSg$             | \
         <>:<PPro1DatPl>             $PPro1DatPl$             | \
         <>:<PPro1DatSg>             $PPro1DatSg$             | \
         <>:<PPro1GenPl>             $PPro1GenPl$             | \
         <>:<PPro1GenSg>             $PPro1GenSg$             | \
         <>:<PPro1NomPl>             $PPro1NomPl$             | \
         <>:<PPro1NomSg>             $PPro1NomSg$             | \
         <>:<PPro2AccPl>             $PPro2AccPl$             | \
         <>:<PPro2AccSg>             $PPro2AccSg$             | \
         <>:<PPro2DatPl>             $PPro2DatPl$             | \
         <>:<PPro2DatSg>             $PPro2DatSg$             | \
         <>:<PPro2GenPl>             $PPro2GenPl$             | \
         <>:<PPro2GenSg>             $PPro2GenSg$             | \
         <>:<PPro2NomPl>             $PPro2NomPl$             | \
         <>:<PPro2NomSg>             $PPro2NomSg$             | \
         <>:<PProFemAccSg>           $PProFemAccSg$           | \
         <>:<PProFemDatSg>           $PProFemDatSg$           | \
         <>:<PProFemGenSg>           $PProFemGenSg$           | \
         <>:<PProFemNomSg>           $PProFemNomSg$           | \
         <>:<PProMascAccSg>          $PProMascAccSg$          | \
         <>:<PProMascDatSg>          $PProMascDatSg$          | \
         <>:<PProMascGenSg>          $PProMascGenSg$          | \
         <>:<PProMascNomSg>          $PProMascNomSg$          | \
         <>:<PProNeutAccSg>          $PProNeutAccSg$          | \
         <>:<PProNeutAccSg-s>        $PProNeutAccSg-s$        | \
         <>:<PProNeutDatSg>          $PProNeutDatSg$          | \
         <>:<PProNeutGenSg>          $PProNeutGenSg$          | \
         <>:<PProNeutNomSg>          $PProNeutNomSg$          | \
         <>:<PProNeutNomSg-s>        $PProNeutNomSg-s$        | \
         <>:<PProNoGendAccPl>        $PProNoGendAccPl$        | \
         <>:<PProNoGendDatPl>        $PProNoGendDatPl$        | \
         <>:<PProNoGendGenPl>        $PProNoGendGenPl$        | \
         <>:<PProNoGendNomPl>        $PProNoGendNomPl$        | \
         <>:<PRecPl>                 $PRecPl$                 | \
         <>:<PRefl1AccSg>            $PRefl1AccSg$            | \
         <>:<PRefl1DatSg>            $PRefl1DatSg$            | \
         <>:<PRefl2AccSg>            $PRefl2AccSg$            | \
         <>:<PRefl2DatSg>            $PRefl2DatSg$            | \
         <>:<PRefl1Pl>               $PRefl1Pl$               | \
         <>:<PRefl2Pl>               $PRefl2Pl$               | \
         <>:<PRefl3>                 $PRefl3$                 | \
         <>:<Prep>                   $Prep$                   | \
         <>:<Prep+Art-m>             $Prep+Art-m$             | \
         <>:<Prep+Art-n>             $Prep+Art-n$             | \
         <>:<Prep+Art-r>             $Prep+Art-r$             | \
         <>:<Prep+Art-s>             $Prep+Art-s$             | \
         <>:<ProAdv>                 $ProAdv$                 | \
         <>:<PtclAdj>                $PtclAdj$                | \
         <>:<PtclNeg>                $PtclNeg$                | \
         <>:<Ptcl-zu>                $Ptcl-zu$                | \
         <>:<Rel>                    $Rel$                    | \
         <>:<Rel-welch>              $Rel-welch$              | \
         <>:<RProMascAccSg>          $RProMascAccSg$          | \
         <>:<RProMascDatSg>          $RProMascDatSg$          | \
         <>:<RProMascGenSg>          $RProMascGenSg$          | \
         <>:<RProMascNomSg>          $RProMascNomSg$          | \
         <>:<RProNeutAccSg>          $RProNeutAccSg$          | \
         <>:<RProNeutDatSg>          $RProNeutDatSg$          | \
         <>:<RProNeutGenSg>          $RProNeutGenSg$          | \
         <>:<RProNeutNomSg>          $RProNeutNomSg$          | \
         <>:<Roman>                  $Roman$                  | \
         <>:<VImp>                   $VImp$                   | \
         <>:<VImp-d-t>               $VImp-d-t$               | \
         <>:<VImp-el-er>             $VImp-el-er$             | \
         <>:<VImp-len>               $VImp-len$               | \
         <>:<VImp-m-n>               $VImp-m-n$               | \
         <>:<VImpPl>                 $VImpPl$                 | \
         <>:<VImpPl-sein>            $VImpPl-sein$            | \
         <>:<VImpSg>                 $VImpSg$                 | \
         <>:<VImpSg0>                $VImpSg0$                | \
         <>:<VInf>                   $VInf$                   | \
         <>:<VInf-el-er>             $VInf-el-er$             | \
         <>:<VInf-len>               $VInf-len$               | \
         <>:<VInf_n>                 $VInf_n$                 | \
         <>:<VModPresIndSg>          $VModPresIndSg$          | \
         <>:<VModPresNonIndSg>       $VModPresNonIndSg$       | \
         <>:<VPart>                  $VPart$                  | \
         <>:<VPastInd-d-t_t>         $VPastInd-d-t_t$         | \
         <>:<VPastInd-len>           $VPastInd-len$           | \
         <>:<VPastInd-werden>        $VPastInd-werden$        | \
         <>:<VPastIndPl-werden>      $VPastIndPl-werden$      | \
         <>:<VPastIndSg-ward>        $VPastIndSg-ward$        | \
         <>:<VPastIndStr>            $VPastIndStr$            | \
         <>:<VPastIndStr-s>          $VPastIndStr-s$          | \
         <>:<VPastIndWeak>           $VPastIndWeak$           | \
         <>:<VPastStr>               $VPastStr$               | \
         <>:<VPastStr-s>             $VPastStr-s$             | \
         <>:<VPastSubj-haben>        $VPastSubj-haben$        | \
         <>:<VPastSubj-len>          $VPastSubj-len$          | \
         <>:<VPastSubj2-sein>        $VPastSubj2-sein$        | \
         <>:<VPastSubjOld>           $VPastSubjOld$           | \
         <>:<VPastSubjStr>           $VPastSubjStr$           | \
         <>:<VPastSubjWeak>          $VPastSubjWeak$          | \
         <>:<VPPast-d_t>             $VPPast-d_t$             | \
         <>:<VPPast-d_t><>:<haben>   $VPPast-d_t+haben$       | \
         <>:<VPPast-d_t><>:<sein>    $VPPast-d_t+sein$        | \
         <>:<VPPast-len>             $VPPast-len$             | \
         <>:<VPPast-len><>:<haben>   $VPPast-len+haben$       | \
         <>:<VPPast-len><>:<sein>    $VPPast-len+sein$        | \
         <>:<VPPast_n>               $VPPast_n$               | \
         <>:<VPPast_n><>:<haben>     $VPPast_n+haben$         | \
         <>:<VPPast_n><>:<sein>      $VPPast_n+sein$          | \
         <>:<VPPastStr>              $VPPastStr$              | \
         <>:<VPPastStr><>:<haben>    $VPPastStr+haben$        | \
         <>:<VPPastStr><>:<sein>     $VPPastStr+sein$         | \
         <>:<VPPastWeak>             $VPPastWeak$             | \
         <>:<VPPastWeak><>:<haben>   $VPPastWeak+haben$       | \
         <>:<VPPastWeak><>:<sein>    $VPPastWeak+sein$        | \
         <>:<VPPres>                 $VPPres$                 | \
         <>:<VPPres-el-er>           $VPPres-el-er$           | \
         <>:<VPPres-len>             $VPPres-len$             | \
         <>:<VPres>                  $VPres$                  | \
         <>:<VPres-el-er>            $VPres-el-er$            | \
         <>:<VPres-len>              $VPres-len$              | \
         <>:<VPres-m-n>              $VPres-m-n$              | \
         <>:<VPres-s>                $VPres-s$                | \
         <>:<VPres-tun>              $VPres-tun$              | \
         <>:<VPresInd13Pl-sein>      $VPresInd13Pl-sein$      | \
         <>:<VPresInd1Sg-sein>       $VPresInd1Sg-sein$       | \
         <>:<VPresInd23Sg>           $VPresInd23Sg$           | \
         <>:<VPresInd23Sg-d_t>       $VPresInd23Sg-d_t$       | \
         <>:<VPresInd23Sg-t_0>       $VPresInd23Sg-t_0$       | \
         <>:<VPresInd2Pl-sein>       $VPresInd2Pl-sein$       | \
         <>:<VPresInd2Sg-sein>       $VPresInd2Sg-sein$       | \
         <>:<VPresInd2Sg-werden>     $VPresInd2Sg-werden$     | \
         <>:<VPresInd3Sg-sein>       $VPresInd3Sg-sein$       | \
         <>:<VPresInd3Sg-werden>     $VPresInd3Sg-werden$     | \
         <>:<VPresNonInd23Sg>        $VPresNonInd23Sg$        | \
         <>:<VPresSubj-sein>         $VPresSubj-sein$         | \
         <>:<VWeak>                  $VWeak$                  | \
         <>:<VWeak><>:<haben>        $VWeak+haben$            | \
         <>:<VWeak><>:<sein>         $VWeak+sein$             | \
         <>:<VWeak-d-t>              $VWeak-d-t$              | \
         <>:<VWeak-d-t><>:<haben>    $VWeak-d-t+haben$        | \
         <>:<VWeak-d-t><>:<sein>     $VWeak-d-t+sein$         | \
         <>:<VWeak-el-er>            $VWeak-el-er$            | \
         <>:<VWeak-el-er><>:<haben>  $VWeak-el-er+haben$      | \
         <>:<VWeak-el-er><>:<sein>   $VWeak-el-er+sein$       | \
         <>:<VWeak-len>              $VWeak-len$              | \
         <>:<VWeak-len><>:<haben>    $VWeak-len+haben$        | \
         <>:<VWeak-len><>:<sein>     $VWeak-len+sein$         | \
         <>:<VWeak-m-n>              $VWeak-m-n$              | \
         <>:<VWeak-m-n><>:<haben>    $VWeak-m-n+haben$        | \
         <>:<VWeak-m-n><>:<sein>     $VWeak-m-n+sein$         | \
         <>:<VWeak-s>                $VWeak-s$                | \
         <>:<VWeak-s><>:<haben>      $VWeak-s+haben$          | \
         <>:<VWeak-s><>:<sein>       $VWeak-s+sein$           | \
         <>:<WAdv>                   $WAdv$                   | \
         <>:<W-welch>                $W-welch$                | \
         <>:<WProMascAccSg>          $WProMascAccSg$          | \
         <>:<WProMascDatSg>          $WProMascDatSg$          | \
         <>:<WProMascGenSg>          $WProMascGenSg$          | \
         <>:<WProMascNomSg>          $WProMascNomSg$          | \
         <>:<WProNeutAccSg>          $WProNeutAccSg$          | \
         <>:<WProNeutDatSg>          $WProNeutDatSg$          | \
         <>:<WProNeutGenSg>          $WProNeutGenSg$          | \
         <>:<WProNeutNomSg>          $WProNeutNomSg$


% inflection filter

ALPHABET = [#char# #surface-trigger# #orth-trigger# #phon-trigger# \
            #morph-trigger# #boundary-trigger# <ge><zu>]

$=INFL$ = [#inflection#]:<>

$=AUX$ = [#auxiliary#]:<>

$InflFilter$ = (.* $=INFL$ $=AUX$ $=INFL$ $=AUX$ .*) | \
               (.* $=INFL$ $=INFL$ .*)
