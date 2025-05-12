% infl.fst
% Version 12.6
% Andreas Nolda 2025-05-12

% based on code from SMORLemma by Rico Sennrich
% which is in turn based on code from SMOR by Helmut Schmid

$SS$ = <>:<dbl(s)>
$ZZ$ = <>:<dbl(z)>


% nouns

$NSuff0$ = {<UnmCase><UnmNum>}:{}

$NSuff0_es$ = $NSuff0$ | \
              {<Gen><Sg>}:{<SB>es<del(e)|Gen>}

$NSuff0_s$ = $NSuff0$ | \
             {<Gen><Sg>}:{<SB>s}

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

$NGenSgOldSuff_n$ = {<Nom><Sg>}:{}           | \
                    {<Acc><Sg><Old>}:{<SB>n} | \
                    {<Dat><Sg><Old>}:{<SB>n} | \
                    {<Gen><Sg><Old>}:{<SB>n}

$NGenSgSuff_es$ = {<Nom><Sg>}:{}           | \
                  {<Acc><Sg>}:{}           | \
                  {<Dat><Sg>}:{}           | \
                  {<Dat><Sg><Old>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 317)
                  {<Gen><Sg>}:{<SB>es<del(e)|Gen>}

$NGenSgNonStSuff_es$ = {<Nom><Sg>}:{} | \
                       {<Acc><Sg>}:{} | \
                       {<Dat><Sg>}:{} | \
                       {<Gen><Sg><NonSt>}:{<SB>es<del(e)|Gen>}

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

% Kopf, Kopf(e)s (measure noun)
$NMasc0_es$ = {<+NN><Masc>}:{} $NSuff0_es$

% Faden, Fadens (measure noun)
$NMasc0_s$ = {<+NN><Masc>}:{} $NSuff0_s$

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

% Revers, Revers, Revers, Revers; Gravis, Gravis, Gravis, Gravis
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

% Intercity, Intercity, Intercitys, Intercitys; Taxi, Taxi, Taxis, Taxis
$NMasc_0_s_0$ = {<+NN><Masc>}:{}      $NGenSgSuff_0$ | \
                {<+NN><Masc>}:{<SB>s} $NDatPlSuff_0$

% Signor, Signor, Signori, Signori
$NMasc_0_i_0$ = {<+NN><Masc>}:{}      $NGenSgSuff_0$ | \
                {<+NN><Masc>}:{<SB>i} $NDatPlSuff_0$

% Veda, Veda, Veden, Veden
$NMasc_0_a/en_0$ = {<+NN><Masc>}:{}                   $NGenSgSuff_0$ | \
                   {<+NN><Masc>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Atlas, Atlas, Atlanten, Atlanten
$NMasc_0_as/anten_0$ = {<+NN><Masc>}:{}                      $NGenSgSuff_0$ | \
                       {<+NN><Masc>}:{<del(VC)|Pl>ant<SB>en} $NDatPlSuff_0$

% Carabiniere, Carabiniere, Carabinieri, Carabinieri
$NMasc_0_e/i_0$ = {<+NN><Masc>}:{}                  $NGenSgSuff_0$ | \
                  {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Dens, Dens, Dentes, Dentes
$NMasc_0_ens/entes_0$ = {<+NN><Masc>}:{}                      $NGenSgSuff_0$ | \
                        {<+NN><Masc>}:{<del(VC)|Pl>ent<SB>es} $NDatPlSuff_0$

% Präses, Präses, Präsiden, Präsiden
$NMasc_0_es/iden_0$ = {<+NN><Masc>}:{}                     $NGenSgSuff_0$ | \
                      {<+NN><Masc>}:{<del(VC)|Pl>id<SB>en} $NDatPlSuff_0$

% Präses, Präses, Präsides, Präsides
$NMasc_0_es/ides_0$ = {<+NN><Masc>}:{}                     $NGenSgSuff_0$ | \
                      {<+NN><Masc>}:{<del(VC)|Pl>id<SB>es} $NDatPlSuff_0$

% Index, Index, Indizes, Indizes
$NMasc_0_ex/izes_0$ = {<+NN><Masc>}:{}                     $NGenSgSuff_0$ | \
                      {<+NN><Masc>}:{<del(VC)|Pl>iz<SB>es} $NDatPlSuff_0$

% Taxi, Taxi, Taxen, Taxen
$NMasc_0_i/en_0$ = $NMasc_0_a/en_0$

% Gravis, Gravis, Graves, Graves
$NMasc_0_is/es_0$ = {<+NN><Masc>}:{}                   $NGenSgSuff_0$ | \
                    {<+NN><Masc>}:{<del(VC)|Pl><SB>es} $NDatPlSuff_0$

% Appendix, Appendix, Appendizes, Appendizes
$NMasc_0_ix/izes_0$ = $NMasc_0_ex/izes_0$

% Saldo, Saldo, Salden, Salden
$NMasc_0_o/en_0$ = $NMasc_0_a/en_0$

% Espresso, Espresso, Espressi, Espressi
$NMasc_0_o/i_0$ = $NMasc_0_e/i_0$

% Mythos, Mythos, Mythen, Mythen
$NMasc_0_os/en_0$ = $NMasc_0_a/en_0$

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

% Virus, Virus, Viren, Viren
$NMasc_0_us/en_0$ = $NMasc_0_a/en_0$

% Kaktus, Kaktus, Kakteen, Kakteen
$NMasc_0_us/een_0$ = {<+NN><Masc>}:{}                    $NGenSgSuff_0$ | \
                     {<+NN><Masc>}:{<del(VC)|Pl>e<SB>en} $NDatPlSuff_0$

% Kanonikus, Kanonikus, Kanoniker, Kanonikern
$NMasc_0_us/er_n$ = {<+NN><Masc>}:{}                   $NGenSgSuff_0$ | \
                    {<+NN><Masc>}:{<del(VC)|Pl><SB>er} $NDatPlSuff_n$

% Intimus, Intimus, Intimi, Intimi
$NMasc_0_us/i_0$ = $NMasc_0_e/i_0$

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

% Arzt, Arzt(e)s, Ärzte, Ärzten; Kopf, Kopf(e)s, Köpfe, Köpfen
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

% Appendix, Appendixes, Appendizes, Appendizes
$NMasc_es_ix/izes_0$ = $NMasc_es_ex/izes_0$

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

% Garten, Gartens, Gärten, Gärten; Schaden, Schadens, Schäden; Faden, Fadens, Fäden, Fäden
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

% Versal, Versals, Versalien, Versalien
$NMasc_s_ien_0$ = {<+NN><Masc>}:{}        $NGenSgSuff_s$ | \
                  {<+NN><Masc>}:{i<SB>en} $NDatPlSuff_0$

% Embryo, Embryos, Embryonen, Embryonen (masculine)
$NMasc_s_nen_0$ = {<+NN><Masc>}:{}        $NGenSgSuff_s$ | \
                  {<+NN><Masc>}:{n<SB>en} $NDatPlSuff_0$

% Intercity, Intercitys, Intercitys, Intercitys; Taxi, Taxis, Taxis, Taxis
$NMasc_s_s_0$ = {<+NN><Masc>}:{}      $NGenSgSuff_s$ | \
                {<+NN><Masc>}:{<SB>s} $NDatPlSuff_0$

% Veda, Vedas, Veden, Veden
$NMasc_s_a/en_0$ = {<+NN><Masc>}:{}                   $NGenSgSuff_s$ | \
                   {<+NN><Masc>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Carabiniere, Carabinieres, Carabinieri, Carabinieri
$NMasc_s_e/i_0$ = {<+NN><Masc>}:{}                  $NGenSgSuff_s$ | \
                  {<+NN><Masc>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Pater, Paters, Patres, Patres
$NMasc_s_er/res_0$ = {<+NN><Masc>}:{}                    $NGenSgSuff_s$ | \
                     {<+NN><Masc>}:{<del(VC)|Pl>r<SB>es} $NDatPlSuff_0$

% Taxi, Taxis, Taxen, Taxen
$NMasc_s_i/en_0$ = $NMasc_s_a/en_0$

% Saldo, Saldos, Salden, Salden
$NMasc_s_o/en_0$ = $NMasc_s_a/en_0$

% Espresso, Espressos, Espressi, Espressi
$NMasc_s_o/i_0$ = $NMasc_s_e/i_0$

% Fels, Felsen, Felsen, Felsen; Mensch, Menschen, Menschen, Menschen
$NMasc_en_en_0$ = {<+NN><Masc>}:{}       $NGenSgSuff_en$ | \
                  {<+NN><Masc>}:{<SB>en} $NDatPlSuff_0$

% Affe, Affen, Affen, Affen; Junge, Jungen, Jungen, Jungen
$NMasc_n_n_0$ = {<+NN><Masc>}:{}      $NGenSgSuff_n$ | \
                {<+NN><Masc>}:{<SB>n} $NDatPlSuff_0$

% Junge, Jungen, Jungens, Jungens
$NMasc_n_ns_0$ = {<+NN><Masc>}:{}       $NGenSgSuff_n$ | \
                 {<+NN><Masc>}:{<SB>ns} $NDatPlSuff_0$

% Junge, Jungen, Jungs, Jungs
$NMasc_n_e/s_0$ = {<+NN><Masc>}:{}                  $NGenSgSuff_n$ | \
                  {<+NN><Masc>}:{<del(VC)|Pl><SB>s} $NDatPlSuff_0$

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

% Paar, Paar(e)s (measure noun)
$NNeut0_es$ = {<+NN><Neut>}:{} $NSuff0_es$

% Kilo, Kilo(s) (measure noun)
$NNeut0_s$ = {<+NN><Neut>}:{} $NSuff0_s$

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

% Relais, Relais, Relais, Relais; Quiz, Quiz, Quiz, Quiz
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

% Requiem, Requiem, Requien, Requien
$NNeut_0_em/en_0$ = $NNeut_0_a/en_0$

% Examen, Examen, Examina, Examina
$NNeut_0_en/ina_0$ = {<+NN><Neut>}:{}                    $NGenSgSuff_0$ | \
                     {<+NN><Neut>}:{<del(VC)|Pl>in<SB>a} $NDatPlSuff_0$

% Akzidens, Akzidens, Akzidentia, Akzidentia
$NNeut_0_ens/entia_0$ = {<+NN><Neut>}:{}                      $NGenSgSuff_0$ | \
                        {<+NN><Neut>}:{<del(VC)|Pl>enti<SB>a} $NDatPlSuff_0$

% Akzidens, Akzidens, Akzidentien, Akzidentien
$NNeut_0_ens/entien_0$ = {<+NN><Neut>}:{}                       $NGenSgSuff_0$ | \
                         {<+NN><Neut>}:{<del(VC)|Pl>enti<SB>en} $NDatPlSuff_0$

% Akzidens, Akzidens, Akzidenzien, Akzidenzien
$NNeut_0_ens/enzien_0$ = {<+NN><Neut>}:{}                       $NGenSgSuff_0$ | \
                         {<+NN><Neut>}:{<del(VC)|Pl>enzi<SB>en} $NDatPlSuff_0$

% Simplex, Simplex, Simplizia, Simplizia
$NNeut_0_ex/izia_0$ = {<+NN><Neut>}:{}                     $NGenSgSuff_0$ | \
                      {<+NN><Neut>}:{<del(VC)|Pl>iz<SB>ia} $NDatPlSuff_0$

% Taxi, Taxi, Taxen, Taxen
$NNeut_0_i/en_0$ = $NNeut_0_a/en_0$

% Konto, Konto, Konten, Konten
$NNeut_0_o/en_0$ = $NNeut_0_a/en_0$

% Intermezzo, Intermezzo, Intermezzi, Intermezzi
$NNeut_0_o/i_0$ = $NNeut_0_e/i_0$

% Oxymoron, Oxymoron, Oxymora, Oxymora
$NNeut_0_on/a_0$ = {<+NN><Neut>}:{}                  $NGenSgSuff_0$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>a} $NDatPlSuff_0$

% Stadion, Stadion, Stadien, Stadien
$NNeut_0_on/en_0$ = $NNeut_0_a/en_0$

% Epos, Epos, Epen, Epen
$NNeut_0_os/en_0$ = $NNeut_0_a/en_0$

% Aktivum, Aktivum, Aktiva, Aktiva
$NNeut_0_um/a_0$ = $NNeut_0_on/a_0$

% Museum, Museum, Museen, Museen
$NNeut_0_um/en_0$ = $NNeut_0_a/en_0$

% Virus, Virus, Viren, Viren
$NNeut_0_us/en_0$ = $NNeut_0_a/en_0$

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

% Quiz, Quizzes, Quizze, Quizzen (coll.)
$NNeut_es_e_n~zz$ = $ZZ$ {<+NN><Neut>}:{}      $NGenSgNonStSuff_es$ | \
                    $ZZ$ {<+NN><Neut>}:{<SB>e} $NDatPlSuff_n$ {<NonSt>}:{}

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

% Simplex, Simplexes, Simplizia, Simplizia
$NNeut_es_ex/izia_0$ = {<+NN><Neut>}:{}                     $NGenSgSuff_es$ | \
                       {<+NN><Neut>}:{<del(VC)|Pl>iz<SB>ia} $NDatPlSuff_0$

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

% Requiem, Requiems, Requien, Requien
$NNeut_s_em/en_0$ = $NNeut_s_a/en_0$

% Examen, Examens, Examina, Examina
$NNeut_s_en/ina_0$ = {<+NN><Neut>}:{}                    $NGenSgSuff_s$ | \
                     {<+NN><Neut>}:{<del(VC)|Pl>in<SB>a} $NDatPlSuff_0$

% Taxi, Taxis, Taxen, Taxen
$NNeut_s_i/en_0$ = $NNeut_s_a/en_0$

% Konto, Kontos, Konten, Konten
$NNeut_s_o/en_0$ = $NNeut_s_a/en_0$

% Intermezzo, Intermezzos, Intermezzi, Intermezzi
$NNeut_s_o/i_0$ = $NNeut_s_e/i_0$

% Oxymoron, Oxymorons, Oxymora, Oxymora
$NNeut_s_on/a_0$ = {<+NN><Neut>}:{}                  $NGenSgSuff_s$ | \
                   {<+NN><Neut>}:{<del(VC)|Pl><SB>a} $NDatPlSuff_0$

% Stadion, Stadions, Stadien, Stadien
$NNeut_s_on/en_0$ = $NNeut_s_a/en_0$

% Aktivum, Aktivums, Aktiva, Aktiva
$NNeut_s_um/a_0$ = $NNeut_s_on/a_0$

% Museum, Museums, Museen, Museen
$NNeut_s_um/en_0$ = $NNeut_s_a/en_0$

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

% Hand (measure noun)
$NFem0$ = {<+NN><Fem>}:{} $NSuff0$

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

% Vita, Vita, Vitae, Vitae
$NFem_0_e_0$ = {<+NN><Fem>}:{}      $NGenSgSuff_0$ | \
               {<+NN><Fem>}:{<SB>e} $NDatPlSuff_0$

% Drangsal, Drangsal, Drangsale, Drangsalen
$NFem_0_e_n$ = {<+NN><Fem>}:{}      $NGenSgSuff_0$ | \
               {<+NN><Fem>}:{<SB>e} $NDatPlSuff_n$

% Kenntnis, Kenntnis, Kenntnisse, Kenntnissen
$NFem_0_e_n~ss$ = $SS$ $NFem_0_e_n$

% Wand, Wand, Wände, Wänden; Hand, Hand, Hände, Händen
$NFem_0_\$e_n$ = {<+NN><Fem>}:{}           $NGenSgSuff_0$ | \
                 {<+NN><Fem>}:{<uml><SB>e} $NDatPlSuff_n$

% Frau, Frau, Frauen, Frauen; Arbeit, Arbeit, Arbeiten, Arbeiten
$NFem_0_en_0$ = {<+NN><Fem>}:{}       $NGenSgSuff_0$ | \
                {<+NN><Fem>}:{<SB>en} $NDatPlSuff_0$

% Werkstatt, Werkstatt, Werkstätten, Werkstätten
$NFem_0_\$en_0$ = {<+NN><Fem>}:{}            $NGenSgSuff_0$ | \
                  {<+NN><Fem>}:{<uml><SB>en} $NDatPlSuff_0$

% Hilfe, Hilfe, Hilfen, Hilfen; Gnade, Gnade, Gnaden, Gnaden
$NFem_0_n_0$ = {<+NN><Fem>}:{}      $NGenSgSuff_0$ | \
               {<+NN><Fem>}:{<SB>n} $NDatPlSuff_0$

% Smartwatch, Smartwatch, Smartwatches, Smartwatches
$NFem_0_es_0$ = {<+NN><Fem>}:{}       $NGenSgSuff_0$ | \
                {<+NN><Fem>}:{<SB>es} $NDatPlSuff_0$

% Pizza, Pizza, Pizzas, Pizzas; City, City, Citys, Citys
$NFem_0_s_0$ = {<+NN><Fem>}:{}      $NGenSgSuff_0$ | \
               {<+NN><Fem>}:{<SB>s} $NDatPlSuff_0$

% Vigil, Vigil, Vigilien, Vigilien
$NFem_0_ien_0$ = {<+NN><Fem>}:{}        $NGenSgSuff_0$ | \
                 {<+NN><Fem>}:{i<SB>en} $NDatPlSuff_0$

% Laudatio, Laudatio, Laudationes, Laudationes
$NFem_0_nes_0$ = {<+NN><Fem>}:{}        $NGenSgSuff_0$ | \
                 {<+NN><Fem>}:{n<SB>es} $NDatPlSuff_0$

% Pizza, Pizza, Pizze, Pizze
$NFem_0_a/e_0$ = {<+NN><Fem>}:{}                  $NGenSgSuff_0$ | \
                 {<+NN><Fem>}:{<del(VC)|Pl><SB>e} $NDatPlSuff_0$

% Pizza, Pizza, Pizzen, Pizzen; Firma, Firma, Firmen, Firmen
$NFem_0_a/en_0$ = {<+NN><Fem>}:{}                   $NGenSgSuff_0$ | \
                  {<+NN><Fem>}:{<del(VC)|Pl><SB>en} $NDatPlSuff_0$

% Spirans, Spirans, Spiranten, Spiranten
$NFem_0_ans/anten_0$ = {<+NN><Fem>}:{}                      $NGenSgSuff_0$ | \
                       {<+NN><Fem>}:{<del(VC)|Pl>ant<SB>en} $NDatPlSuff_0$

% Phalanx, Phalanx, Phalangen, Phalangen
$NFem_0_anx/angen_0$ = {<+NN><Fem>}:{}                      $NGenSgSuff_0$ | \
                       {<+NN><Fem>}:{<del(VC)|Pl>ang<SB>en} $NDatPlSuff_0$

% Minestrone, Minestrone, Minestroni, Minestroni
$NFem_0_e/i_0$ = {<+NN><Fem>}:{}                  $NGenSgSuff_0$ | \
                 {<+NN><Fem>}:{<del(VC)|Pl><SB>i} $NDatPlSuff_0$

% Spezies, Spezies, Spezien, Spezien
$NFem_0_es/en_0$ = $NFem_0_a/en_0$

% Lex, Lex, Leges, Leges
$NFem_0_ex/eges_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>eg<SB>es} $NDatPlSuff_0$

% Basis, Basis, Basen, Basen
$NFem_0_is/en_0$ = $NFem_0_a/en_0$

% Apsis, Apsis, Apsiden, Apsiden
$NFem_0_is/iden_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>id<SB>en} $NDatPlSuff_0$

% Glottis, Glottis, Glottides, Glottides
$NFem_0_is/ides_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>id<SB>es} $NDatPlSuff_0$

% Helix, Helix, Helices, Helices
$NFem_0_ix/ices_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>ic<SB>es} $NDatPlSuff_0$

% Matrix, Matrix, Matrizen, Matrizen
$NFem_0_ix/izen_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>iz<SB>en} $NDatPlSuff_0$

% Radix, Radix, Radizes, Radizes
$NFem_0_ix/izes_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>iz<SB>es} $NDatPlSuff_0$

% Dos, Dos, Dotes, Dotes
$NFem_0_os/otes_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>ot<SB>es} $NDatPlSuff_0$

% Vox, Vox, Voces, Voces
$NFem_0_ox/oces_0$ = {<+NN><Fem>}:{}                     $NGenSgSuff_0$ | \
                     {<+NN><Fem>}:{<del(VC)|Pl>oc<SB>es} $NDatPlSuff_0$

% Gnade, Gnaden (archaic), Gnaden, Gnaden
$NFem_n_n_0$ = {<+NN><Fem>}:{}      $NGenSgOldSuff_n$ | \
               {<+NN><Fem>}:{<SB>n} $NDatPlSuff_0$

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
$NUnmGend|Pl_0$ = {<+NN><UnmGend>}:{} $NDatPlSuff_0$

% Leute, Leuten
$NUnmGend|Pl_n$ = {<+NN><UnmGend>}:{} $NDatPlSuff_n$


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

$NameUnmGend|Pl_0$ = {<+NPROP><UnmGend>}:{} $NDatPlSuff_0$

$NameUnmGend|Pl_n$ = {<+NPROP><UnmGend>}:{} $NDatPlSuff_n$


% adjectives

$AdjInflSuff$ = {<Attr/Subst><Masc><Nom><Sg><St>}:{<SB>er}    | \
                {<Attr/Subst><Masc><Acc><Sg><St>}:{<SB>en}    | \
                {<Attr/Subst><Masc><Dat><Sg><St>}:{<SB>em}    | \
                {<Attr/Subst><Masc><Gen><Sg><St>}:{<SB>en}    | \
                {<Attr/Subst><Neut><Nom><Sg><St>}:{<SB>es}    | \
                {<Attr/Subst><Neut><Acc><Sg><St>}:{<SB>es}    | \
                {<Attr/Subst><Neut><Dat><Sg><St>}:{<SB>em}    | \
                {<Attr/Subst><Neut><Gen><Sg><St>}:{<SB>en}    | \
                {<Attr/Subst><Fem><Nom><Sg><St>}:{<SB>e}      | \
                {<Attr/Subst><Fem><Acc><Sg><St>}:{<SB>e}      | \
                {<Attr/Subst><Fem><Dat><Sg><St>}:{<SB>er}     | \
                {<Attr/Subst><Fem><Gen><Sg><St>}:{<SB>er}     | \
                {<Attr/Subst><UnmGend><Nom><Pl><St>}:{<SB>e}  | \
                {<Attr/Subst><UnmGend><Acc><Pl><St>}:{<SB>e}  | \
                {<Attr/Subst><UnmGend><Dat><Pl><St>}:{<SB>en} | \
                {<Attr/Subst><UnmGend><Gen><Pl><St>}:{<SB>er} | \
                {<Attr/Subst><Masc><Nom><Sg><Wk>}:{<SB>e}     | \
                {<Attr/Subst><Masc><Acc><Sg><Wk>}:{<SB>en}    | \
                {<Attr/Subst><Masc><Dat><Sg><Wk>}:{<SB>en}    | \
                {<Attr/Subst><Masc><Gen><Sg><Wk>}:{<SB>en}    | \
                {<Attr/Subst><Neut><Nom><Sg><Wk>}:{<SB>e}     | \
                {<Attr/Subst><Neut><Acc><Sg><Wk>}:{<SB>e}     | \
                {<Attr/Subst><Neut><Dat><Sg><Wk>}:{<SB>en}    | \
                {<Attr/Subst><Neut><Gen><Sg><Wk>}:{<SB>en}    | \
                {<Attr/Subst><Fem><Nom><Sg><Wk>}:{<SB>e}      | \
                {<Attr/Subst><Fem><Acc><Sg><Wk>}:{<SB>e}      | \
                {<Attr/Subst><Fem><Dat><Sg><Wk>}:{<SB>en}     | \
                {<Attr/Subst><Fem><Gen><Sg><Wk>}:{<SB>en}     | \
                {<Attr/Subst><UnmGend><Nom><Pl><Wk>}:{<SB>en} | \
                {<Attr/Subst><UnmGend><Acc><Pl><Wk>}:{<SB>en} | \
                {<Attr/Subst><UnmGend><Dat><Pl><Wk>}:{<SB>en} | \
                {<Attr/Subst><UnmGend><Gen><Pl><Wk>}:{<SB>en}

$AdjInflSuff-n$ = {<Attr/Subst><Masc><Acc><Sg><St>}:{<SB>n}    | \
                  {<Attr/Subst><Masc><Gen><Sg><St>}:{<SB>n}    | \
                  {<Attr/Subst><Neut><Gen><Sg><St>}:{<SB>n}    | \
                  {<Attr/Subst><UnmGend><Dat><Pl><St>}:{<SB>n} | \
                  {<Attr/Subst><Masc><Acc><Sg><Wk>}:{<SB>n}    | \
                  {<Attr/Subst><Masc><Dat><Sg><Wk>}:{<SB>n}    | \
                  {<Attr/Subst><Masc><Gen><Sg><Wk>}:{<SB>n}    | \
                  {<Attr/Subst><Neut><Dat><Sg><Wk>}:{<SB>n}    | \
                  {<Attr/Subst><Neut><Gen><Sg><Wk>}:{<SB>n}    | \
                  {<Attr/Subst><Fem><Dat><Sg><Wk>}:{<SB>n}     | \
                  {<Attr/Subst><Fem><Gen><Sg><Wk>}:{<SB>n}     | \
                  {<Attr/Subst><UnmGend><Nom><Pl><Wk>}:{<SB>n} | \
                  {<Attr/Subst><UnmGend><Acc><Pl><Wk>}:{<SB>n} | \
                  {<Attr/Subst><UnmGend><Dat><Pl><Wk>}:{<SB>n} | \
                  {<Attr/Subst><UnmGend><Gen><Pl><Wk>}:{<SB>n}

$AdjInflSuff-m$ = {<Attr/Subst><Masc><Dat><Sg><St>}:{<SB>m} | \
                  {<Attr/Subst><Neut><Dat><Sg><St>}:{<SB>m}

% tabu
$AdjPosPred$ = {<+ADJ><Pos><Pred/Adv>}:{}

% pleite
$AdjPosPred-e$ = {<+ADJ><Pos><Pred/Adv>}:{<SB>e}

% zig
$AdjPosAttr0$ = {<+ADJ><Pos><Attr><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

$AdjPosAttr0-e$ = {<+ADJ><Pos><Attr><UnmGend><UnmCase><UnmNum><UnmInfl>}:{<SB>e}

% Berliner ('related to Berlin')
$AdjPosAttrSubst0$ = {<+ADJ><Pos><Attr/Subst><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

% vorig-; hoh-
$AdjPosAttr$ = {<+ADJ><Pos>}:{} $AdjInflSuff$

% ander-; vorder-
$AdjPosAttr-er$ = $AdjPosAttr$                               | \
                  {<+ADJ><Pos>}:{<del(e)|ADJ>} $AdjInflSuff$ | \
                  {<+ADJ><Pos>}:{} $AdjInflSuff-n$           | \
                  {<+ADJ><Pos>}:{} $AdjInflSuff-m$

% mittler-
$AdjPosAttr-ler$ = $AdjPosAttr$                               | \
                   {<+ADJ><Pos>}:{} $AdjInflSuff-n$           | \
                   {<+ADJ><Pos>}:{} $AdjInflSuff-m$

% lila
$AdjPos0$ = $AdjPosPred$ | \
            $AdjPosAttr0$

% klasse
$AdjPos0-e$ = $AdjPosPred-e$ | \
              $AdjPosAttr0-e$

% viel; wenig
$AdjPos0-viel$ = $AdjPosPred$ | \
                 $AdjPosAttrSubst0$

% derartig; famos; bloß
$AdjPos$ = $AdjPosPred$ | \
           $AdjPosAttr$

% leise
$AdjPos-e$ = $AdjPosPred-e$ | \
             $AdjPosAttr$

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

% mehr; weniger
$AdjComp0$ = {<+ADJ><Comp><Pred/Adv>}:{} | \
             {<+ADJ><Comp><Attr/Subst><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

% besser; höher
$AdjComp_er$ = {<+ADJ><Comp><Pred/Adv>}:{<SB>er} | \
               {<+ADJ><Comp>}:{<SB>er} $AdjInflSuff$

% dunkler
$AdjComp-el_er$ = {}:{<del(e)|ADJ>} $AdjComp_er$

% bitt(e)rer
$AdjComp-er_er$ = $AdjComp_er$ | \
                  {}:{<del(e)|ADJ>} $AdjComp_er$

% trock(e)ner
$AdjComp-en_er$ = $AdjComp-er_er$

$AdjComp_\$er$ = {<+ADJ><Comp><Pred/Adv>}:{<uml><SB>er} | \
                 {<+ADJ><Comp>}:{<uml><SB>er} $AdjInflSuff$

% vordersten
$AdjSupAttr_st$ = {<+ADJ><Sup>}:{<SB>st} $AdjInflSuff$

$AdjSupAttr_est$ = {<+ADJ><Sup>}:{<SB>est} $AdjInflSuff$

% besten; höchsten
$AdjSup_st$ = {<+ADJ><Sup><Pred/Adv>}:{<SB>st<SB>en} | \
              {<+ADJ><Sup>}:{<SB>st} $AdjInflSuff$

% fittesten
$AdjSup_est$ = {<+ADJ><Sup><Pred/Adv>}:{<SB>est<SB>en} | \
               {<+ADJ><Sup>}:{<SB>est} $AdjInflSuff$

$AdjSup_\$st$ = {<+ADJ><Sup><Pred/Adv>}:{<uml><SB>st<SB>en} | \
                {<+ADJ><Sup>}:{<uml><SB>st} $AdjInflSuff$

$AdjSup_\$est$ = {<+ADJ><Sup><Pred/Adv>}:{<uml><SB>est<SB>en} | \
                 {<+ADJ><Sup>}:{<uml><SB>est} $AdjInflSuff$

% hell, heller, hellsten
$Adj_er_st$ = $AdjPos$     | \
              $AdjComp_er$ | \
              $AdjSup_st$

% bunt, bunter, buntesten
$Adj_er_est$ = $AdjPos$     | \
               $AdjComp_er$ | \
               $AdjSup_est$

% warm, wärmer, wärmsten
$Adj_er_\$st$ = $AdjPos$       | \
                $AdjComp_\$er$ | \
                $AdjSup_\$st$

% kalt, kälter, kältesten
$Adj_er_\$est$ = $AdjPos$       | \
                 $AdjComp_\$er$ | \
                 $AdjSup_\$est$


% articles and pronouns

$ArtDefAttrSuff$ = {<Attr><Masc><Nom><Sg><St>}:{<SB>er}    | \
                   {<Attr><Masc><Acc><Sg><St>}:{<SB>en}    | \
                   {<Attr><Masc><Dat><Sg><St>}:{<SB>em}    | \
                   {<Attr><Masc><Gen><Sg><St>}:{<SB>es}    | \
                   {<Attr><Neut><Nom><Sg><St>}:{<SB>as}    | \
                   {<Attr><Neut><Acc><Sg><St>}:{<SB>as}    | \
                   {<Attr><Neut><Dat><Sg><St>}:{<SB>em}    | \
                   {<Attr><Neut><Gen><Sg><St>}:{<SB>es}    | \
                   {<Attr><Fem><Nom><Sg><St>}:{<SB>ie}     | \
                   {<Attr><Fem><Acc><Sg><St>}:{<SB>ie}     | \
                   {<Attr><Fem><Dat><Sg><St>}:{<SB>er}     | \
                   {<Attr><Fem><Gen><Sg><St>}:{<SB>er}     | \
                   {<Attr><UnmGend><Nom><Pl><St>}:{<SB>ie} | \
                   {<Attr><UnmGend><Acc><Pl><St>}:{<SB>ie} | \
                   {<Attr><UnmGend><Dat><Pl><St>}:{<SB>en} | \
                   {<Attr><UnmGend><Gen><Pl><St>}:{<SB>er}

$ArtDefSubstSuff$ = {<Subst><Masc><Nom><Sg><St>}:{<SB>er}      | \
                    {<Subst><Masc><Acc><Sg><St>}:{<SB>en}      | \
                    {<Subst><Masc><Dat><Sg><St>}:{<SB>em}      | \
                    {<Subst><Masc><Gen><Sg><St>}:{<SB>essen}   | \
                    {<Subst><Neut><Nom><Sg><St>}:{<SB>as}      | \
                    {<Subst><Neut><Acc><Sg><St>}:{<SB>as}      | \
                    {<Subst><Neut><Dat><Sg><St>}:{<SB>em}      | \
                    {<Subst><Neut><Gen><Sg><St>}:{<SB>essen}   | \
                    {<Subst><Fem><Nom><Sg><St>}:{<SB>ie}       | \
                    {<Subst><Fem><Acc><Sg><St>}:{<SB>ie}       | \
                    {<Subst><Fem><Dat><Sg><St>}:{<SB>er}       | \
                    {<Subst><Fem><Gen><Sg><St>}:{<SB>erer}     | \
                    {<Subst><Fem><Gen><Sg><St>}:{<SB>eren}     | \
                    {<Subst><UnmGend><Nom><Pl><St>}:{<SB>ie}   | \
                    {<Subst><UnmGend><Acc><Pl><St>}:{<SB>ie}   | \
                    {<Subst><UnmGend><Dat><Pl><St>}:{<SB>enen} | \
                    {<Subst><UnmGend><Gen><Pl><St>}:{<SB>erer} | \
                    {<Subst><UnmGend><Gen><Pl><St>}:{<SB>eren}

$ArtDefSuff$ = $ArtDefAttrSuff$ | \
               $ArtDefSubstSuff$

$RelSuff$ = $ArtDefSubstSuff$

$DemDefSuff$ = $ArtDefSuff$

$DemSuff$ = {[<Attr><Subst>]<Masc><Nom><Sg><St>}:{<SB>er}    | \
            {[<Attr><Subst>]<Masc><Acc><Sg><St>}:{<SB>en}    | \
            {[<Attr><Subst>]<Masc><Dat><Sg><St>}:{<SB>em}    | \
            {[<Attr><Subst>]<Masc><Gen><Sg><St>}:{<SB>es}    | \
            {<Attr><Masc><Gen><Sg><St><NonSt>}:{<SB>en}      | \ % cf. Duden-Grammatik (2016: § 356, 379)
            {[<Attr><Subst>]<Neut><Nom><Sg><St>}:{<SB>es}    | \
            {[<Attr><Subst>]<Neut><Acc><Sg><St>}:{<SB>es}    | \
            {[<Attr><Subst>]<Neut><Dat><Sg><St>}:{<SB>em}    | \
            {[<Attr><Subst>]<Neut><Gen><Sg><St>}:{<SB>es}    | \
            {<Attr><Neut><Gen><Sg><St><NonSt>}:{<SB>en}      | \ % cf. Duden-Grammatik (2016: § 356, 379)
            {[<Attr><Subst>]<Fem><Nom><Sg><St>}:{<SB>e}      | \
            {[<Attr><Subst>]<Fem><Acc><Sg><St>}:{<SB>e}      | \
            {[<Attr><Subst>]<Fem><Dat><Sg><St>}:{<SB>er}     | \
            {[<Attr><Subst>]<Fem><Gen><Sg><St>}:{<SB>er}     | \
            {[<Attr><Subst>]<UnmGend><Nom><Pl><St>}:{<SB>e}  | \
            {[<Attr><Subst>]<UnmGend><Acc><Pl><St>}:{<SB>e}  | \
            {[<Attr><Subst>]<UnmGend><Dat><Pl><St>}:{<SB>en} | \
            {[<Attr><Subst>]<UnmGend><Gen><Pl><St>}:{<SB>er}

$DemSuff-dies$ = $DemSuff$ | \
                 {[<Attr><Subst>]<Neut><Nom><Sg><St>}:{} | \
                 {[<Attr><Subst>]<Neut><Acc><Sg><St>}:{}

$DemSuff-solch|St$ = $DemSuff$

$DemSuff-solch|Wk$ = {[<Attr><Subst>]<Masc><Nom><Sg><Wk>}:{<SB>e}     | \
                     {[<Attr><Subst>]<Masc><Acc><Sg><Wk>}:{<SB>en}    | \
                     {[<Attr><Subst>]<Masc><Dat><Sg><Wk>}:{<SB>en}    | \
                     {[<Attr><Subst>]<Masc><Gen><Sg><Wk>}:{<SB>en}    | \
                     {[<Attr><Subst>]<Neut><Nom><Sg><Wk>}:{<SB>e}     | \
                     {[<Attr><Subst>]<Neut><Acc><Sg><Wk>}:{<SB>e}     | \
                     {[<Attr><Subst>]<Neut><Dat><Sg><Wk>}:{<SB>en}    | \
                     {[<Attr><Subst>]<Neut><Gen><Sg><Wk>}:{<SB>en}    | \
                     {[<Attr><Subst>]<Fem><Nom><Sg><Wk>}:{<SB>e}      | \
                     {[<Attr><Subst>]<Fem><Acc><Sg><Wk>}:{<SB>e}      | \
                     {[<Attr><Subst>]<Fem><Dat><Sg><Wk>}:{<SB>en}     | \
                     {[<Attr><Subst>]<Fem><Gen><Sg><Wk>}:{<SB>en}     | \
                     {[<Attr><Subst>]<UnmGend><Nom><Pl><Wk>}:{<SB>en} | \
                     {[<Attr><Subst>]<UnmGend><Acc><Pl><Wk>}:{<SB>en} | \
                     {[<Attr><Subst>]<UnmGend><Dat><Pl><Wk>}:{<SB>en} | \
                     {[<Attr><Subst>]<UnmGend><Gen><Pl><Wk>}:{<SB>en}

$DemSuff-solch$ = $DemSuff-solch|St$ | \
                  $DemSuff-solch|Wk$ | \ % cf. Duden-Grammatik (2016: § 432)
                  {<Attr><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

$DemSuff-alldem$ = {<Subst><Neut><Dat><Sg><St>}:{<SB>em}

$DemSuff0$ = {[<Attr><Subst>]<UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

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

$ArtDef-die+DemUnmGendSuff$ = {<Nom><Pl><Wk>}:{<SB>en} | \
                              {<Acc><Pl><Wk>}:{<SB>en}

$ArtDef-den+DemUnmGendSuff$ = {<Dat><Pl><Wk>}:{<SB>en}

$ArtDef-der+DemUnmGendSuff$ = {<Gen><Pl><Wk>}:{<SB>en}

$WSuff-welch$ = $DemSuff-solch|St$ | \
                {<Attr><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

$RelSuff-welch$ = $WSuff-welch$ % cf. Duden-Grammatik (2016: § 403)

$IndefSuff-welch$ = {<Subst><Masc><Nom><Sg><St>}:{<SB>er}    | \
                    {<Subst><Masc><Acc><Sg><St>}:{<SB>en}    | \
                    {<Subst><Masc><Dat><Sg><St>}:{<SB>em}    | \
                    {<Subst><Masc><Gen><Sg><St>}:{<SB>es}    | \
                    {<Subst><Neut><Nom><Sg><St>}:{<SB>es}    | \
                    {<Subst><Neut><Acc><Sg><St>}:{<SB>es}    | \
                    {<Subst><Neut><Dat><Sg><St>}:{<SB>em}    | \
                    {<Subst><Neut><Gen><Sg><St>}:{<SB>es}    | \
                    {<Subst><Fem><Nom><Sg><St>}:{<SB>e}      | \
                    {<Subst><Fem><Acc><Sg><St>}:{<SB>e}      | \
                    {<Subst><Fem><Dat><Sg><St>}:{<SB>er}     | \
                    {<Subst><Fem><Gen><Sg><St>}:{<SB>er}     | \
                    {<Subst><UnmGend><Nom><Pl><St>}:{<SB>e}  | \
                    {<Subst><UnmGend><Acc><Pl><St>}:{<SB>e}  | \
                    {<Subst><UnmGend><Dat><Pl><St>}:{<SB>en} | \
                    {<Subst><UnmGend><Gen><Pl><St>}:{<SB>er}

$IndefSuff-irgendwelch$ = $DemSuff-solch|St$

$IndefSuff-all$ = $DemSuff-solch|St$                           | \
                  {<Subst><Masc><Dat><Sg><Wk><NonSt>}:{<SB>en} | \ % cf. Duden-Grammatik (2016: § 411)
                  {<Subst><Neut><Dat><Sg><Wk><NonSt>}:{<SB>en} | \ % cf. Duden-Grammatik (2016: § 411)
                  {<Attr><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

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
                        {<Subst><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

$IndefSuff-beid$ = {<Subst><Neut><Nom><Sg><St>}:{<SB>es}            | \
                   {<Subst><Neut><Acc><Sg><St>}:{<SB>es}            | \
                   {<Subst><Neut><Dat><Sg><St>}:{<SB>em}            | \
                   {<Subst><Neut><Gen><Sg><St>}:{<SB>es}            | \
                   {[<Attr><Subst>]<UnmGend><Nom><Pl><St>}:{<SB>e}  | \
                   {[<Attr><Subst>]<UnmGend><Acc><Pl><St>}:{<SB>e}  | \
                   {[<Attr><Subst>]<UnmGend><Dat><Pl><St>}:{<SB>en} | \
                   {[<Attr><Subst>]<UnmGend><Gen><Pl><St>}:{<SB>er} | \
                   {<Subst><Neut><Nom><Sg><Wk>}:{<SB>e}             | \
                   {<Subst><Neut><Acc><Sg><Wk>}:{<SB>e}             | \
                   {<Subst><Neut><Dat><Sg><Wk>}:{<SB>en}            | \
                   {<Subst><Neut><Gen><Sg><Wk>}:{<SB>en}            | \
                   {[<Attr><Subst>]<UnmGend><Nom><Pl><Wk>}:{<SB>en} | \
                   {[<Attr><Subst>]<UnmGend><Acc><Pl><Wk>}:{<SB>en} | \
                   {[<Attr><Subst>]<UnmGend><Dat><Pl><Wk>}:{<SB>en} | \
                   {[<Attr><Subst>]<UnmGend><Gen><Pl><Wk>}:{<SB>en}

$IndefSuff-einig$ = $DemSuff$

$IndefSuff-manch$ = $WSuff-welch$

$IndefSuff-mehrer$ = {[<Attr><Subst>]<Neut><Nom><Sg><St>}:{<SB>es}    | \
                     {[<Attr><Subst>]<Neut><Acc><Sg><St>}:{<SB>es}    | \
                     {[<Attr><Subst>]<UnmGend><Nom><Pl><St>}:{<SB>e}  | \
                     {[<Attr><Subst>]<UnmGend><Acc><Pl><St>}:{<SB>e}  | \
                     {[<Attr><Subst>]<UnmGend><Dat><Pl><St>}:{<SB>en} | \
                     {[<Attr><Subst>]<UnmGend><Gen><Pl><St>}:{<SB>er}

$IndefSuff0$ = {[<Attr><Subst>]<UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

$ArtIndefAttrSuff$ = {<Attr><Masc><Nom><Sg><UnmInfl>}:{}    | \
                     {<Attr><Masc><Acc><Sg><St>}:{<SB>en}   | \
                     {<Attr><Masc><Dat><Sg><St>}:{<SB>em}   | \
                     {<Attr><Masc><Gen><Sg><St>}:{<SB>es}   | \
                     {<Attr><Neut><Nom><Sg><UnmInfl>}:{}    | \
                     {<Attr><Neut><Acc><Sg><UnmInfl>}:{}    | \
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

$ArtNegAttrSuff$ = $ArtIndefAttrSuff$                           | \
                   {<Attr><Masc><Gen><Sg><St><NonSt>}:{<SB>en}  | \ % cf. Duden-Grammatik (2016: § 356, 425)
                   {<Attr><Neut><Gen><Sg><St><NonSt>}:{<SB>en}  | \ % cf. Duden-Grammatik (2016: § 356, 425)
                   {<Attr><UnmGend><Nom><Pl><St>}:{<SB>e}       | \
                   {<Attr><UnmGend><Acc><Pl><St>}:{<SB>e}       | \
                   {<Attr><UnmGend><Dat><Pl><St>}:{<SB>en}      | \
                   {<Attr><UnmGend><Gen><Pl><St>}:{<SB>er}

$ArtNegSubstSuff$ = $ArtIndefSubstSuff$                      | \
                    {<Subst><UnmGend><Nom><Pl><St>}:{<SB>e}  | \
                    {<Subst><UnmGend><Acc><Pl><St>}:{<SB>e}  | \
                    {<Subst><UnmGend><Dat><Pl><St>}:{<SB>en} | \
                    {<Subst><UnmGend><Gen><Pl><St>}:{<SB>er}

$ArtNegSuff$ = $ArtNegAttrSuff$ | \
               $ArtNegSubstSuff$

$IndefSuff-kein$ = $ArtNegSubstSuff$

$PossSuff|St$ = $ArtNegSuff$

$PossSuff|Wk$ = {<Subst><Masc><Nom><Sg><Wk>}:{<SB>e}     | \
                {<Subst><Masc><Acc><Sg><Wk>}:{<SB>en}    | \
                {<Subst><Masc><Dat><Sg><Wk>}:{<SB>en}    | \
                {<Subst><Masc><Gen><Sg><Wk>}:{<SB>en}    | \
                {<Subst><Neut><Nom><Sg><Wk>}:{<SB>e}     | \
                {<Subst><Neut><Acc><Sg><Wk>}:{<SB>e}     | \
                {<Subst><Neut><Dat><Sg><Wk>}:{<SB>en}    | \
                {<Subst><Neut><Gen><Sg><Wk>}:{<SB>en}    | \
                {<Subst><Fem><Nom><Sg><Wk>}:{<SB>e}      | \
                {<Subst><Fem><Acc><Sg><Wk>}:{<SB>e}      | \
                {<Subst><Fem><Dat><Sg><Wk>}:{<SB>en}     | \
                {<Subst><Fem><Gen><Sg><Wk>}:{<SB>en}     | \
                {<Subst><UnmGend><Nom><Pl><Wk>}:{<SB>en} | \
                {<Subst><UnmGend><Acc><Pl><Wk>}:{<SB>en} | \
                {<Subst><UnmGend><Dat><Pl><Wk>}:{<SB>en} | \
                {<Subst><UnmGend><Gen><Pl><Wk>}:{<SB>en}

$PossSuff$ = $PossSuff|St$ | \
             $PossSuff|Wk$

$IProSuff0$ = {<UnmCase><UnmNum>}:{}

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
$ArtDef-die+DemUnmGend$ = {<+DEM>[<Attr><Subst>]<UnmGend>}:{} $ArtDef-die+DemUnmGendSuff$

% denjenigen; denselben (plural)
$ArtDef-den+DemUnmGend$ = {<+DEM>[<Attr><Subst>]<UnmGend>}:{} $ArtDef-den+DemUnmGendSuff$

% derjenigen; derselben (plural)
$ArtDef-der+DemUnmGend$ = {<+DEM>[<Attr><Subst>]<UnmGend>}:{} $ArtDef-der+DemUnmGendSuff$

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
$PProUnmGendNomPl$ = {<+PPRO><Pers><3><UnmGend>}:{} $PProNomPlSuff$

% sie (plural)
$PProUnmGendAccPl$ = {<+PPRO><Pers><3><UnmGend>}:{} $PProAccPlSuff$

% ihr
$PProUnmGendDatPl$ = {<+PPRO><Pers><3><UnmGend>}:{} $PProDatPlSuff$

% ihrer, ihr
$PProUnmGendGenPl$ = {<+PPRO><Pers><3><UnmGend>}:{} $PProGenPlSuff$

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

$CardSuff0$ = {[<Attr><Subst>]<UnmGend><UnmCase><Pl><UnmInfl>}:{}

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

$CardSuff-zwei$ = $CardSuff0$                                      | \
                  {<Subst><UnmGend><Nom><Pl><St><NonSt>}:{<SB>e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><UnmGend><Acc><Pl><St><NonSt>}:{<SB>e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><UnmGend><Dat><Pl><St>}:{<SB>en}         | \ % cf. Duden-Grammatik (2016: § 511)
                  {[<Attr><Subst>]<UnmGend><Gen><Pl><St>}:{<SB>er} | \   % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><UnmGend><Nom><Pl><Wk><NonSt>}:{<SB>e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><UnmGend><Acc><Pl><Wk><NonSt>}:{<SB>e}   | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><UnmGend><Dat><Pl><Wk>}:{<SB>en}             % cf. Duden-Grammatik (2016: § 511)

$CardSuff-vier$ = $CardSuff0$                                    | \
                  {<Subst><UnmGend><Nom><Pl><St><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><UnmGend><Acc><Pl><St><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><UnmGend><Dat><Pl><St>}:{<SB>en}       | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><UnmGend><Nom><Pl><Wk><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><UnmGend><Acc><Pl><Wk><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                  {<Subst><UnmGend><Dat><Pl><Wk>}:{<SB>en}           % cf. Duden-Grammatik (2016: § 511)

$CardSuff-sieben$ = $CardSuff0$                                    | \
                    {<Subst><UnmGend><Nom><Pl><St><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                    {<Subst><UnmGend><Acc><Pl><St><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                    {<Subst><UnmGend><Nom><Pl><Wk><NonSt>}:{<SB>e} | \ % cf. Duden-Grammatik (2016: § 511)
                    {<Subst><UnmGend><Acc><Pl><Wk><NonSt>}:{<SB>e}     % cf. Duden-Grammatik (2016: § 511)

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

% 1, 10
$DigCard$ = {<+CARD><UnmFunc><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

% 1., 10.
$DigOrd$ = {<+ORD><UnmFunc><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

% 1,5, 10,5
$DigFrac$ = {<+FRAC><UnmFunc><UnmGend><UnmCase><Pl><UnmInfl>}:{}

% I, X
$Roman$ = {<+CARD><UnmFunc><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}


% adverbs

% oft; gern; sehr
$Adv$ = {<+ADV>}:{}

% mehr
$AdvComp0$ = {<+ADV><Comp>}:{}

% öfter; lieber
$AdvComp_er$ = {<+ADV><Comp>}:{<SB>er}

% liebsten; meisten
$AdvSup_st$ = {<+ADV><Sup>}:{<SB>st<SB>en}

% öftesten; ehesten
$AdvSup_est$ = {<+ADV><Sup>}:{<SB>est<SB>en}

% darunter
$ProAdv$ = {<+PROADV>}:{}

% wo
$WAdv$ = {<+WADV>}:{}


% verbs

$VInfSuff_en$ = {<+V><Inf><NonCl>}:{<SB>en} | \
                {<+V><Inf><Cl>}:{<ins(zu)><SB>en}

$VInfSuff_n$ = {<+V><Inf><NonCl>}:{<SB>n} | \
               {<+V><Inf><Cl>}:{<ins(zu)><SB>n}

% gehen; sehen; laufen
$VInf$ = $VInfSuff_en$

% notwassern (cf. $SchwaTrigger$ in markers.fst)
$VInf-el-er$ = $VInfSuff_en$

% downcyclen
$VInf-le$ = $VInfSuff_n$

% tun
$VInf_n$ = $VInfSuff_n$

$VPartPresSuff_end$ = {<+V><Part><Pres>}:{<SB>end} | \
                      {<+V><Part><Pres>}:{<ins(zu)><SB>end<rm|Part>} % cf. Duden-Grammatik (2016: § 829)

$VPartPresSuff_nd$ = {<+V><Part><Pres>}:{<SB>nd} | \
                     {<+V><Part><Pres>}:{<ins(zu)><SB>nd<rm|Part>} % cf. Duden-Grammatik (2016: § 829)

% gehend; sehend; laufend
$VPartPres$ = $VPartPresSuff_end$

% notwassernd (cf. $SchwaTrigger$ in markers.fst)
$VPartPres-el-er$ = $VPartPresSuff_end$

% downcyclend
$VPartPres-le$ = $VPartPresSuff_nd$

$VPartPerfSuff_et$ = {<+V><Part><Perf>}:{<ins(ge)><SB><ins(e)>t}

$VPartPerfSuff_t$ = {<+V><Part><Perf>}:{<ins(ge)><SB>t}

$VPartPerfSuff_en$ = {<+V><Part><Perf>}:{<ins(ge)><SB>en}

$VPartPerfSuff_n$ = {<+V><Part><Perf>}:{<ins(ge)><SB>n}

$VPartPerfSuff_ed$ = {<+V><Part><Perf>}:{<ins(ge)><SB>ed}

$haben$ = {<haben>}:{}

$sein$ = {<sein>}:{}

% gehabt; gedacht
$VPartPerfWeak$ = $VPartPerfSuff_et$

$VPartPerfWeak+haben$ = $VPartPerfSuff_et$ $haben$

$VPartPerfWeak+sein$ = $VPartPerfSuff_et$ $sein$

% gegangen; gesehen; gelaufen
$VPartPerfStr$ = $VPartPerfSuff_en$

$VPartPerfStr+haben$ = $VPartPerfSuff_en$ $haben$

$VPartPerfStr+sein$ = $VPartPerfSuff_en$ $sein$

% gesandt; gewandt
$VPartPerf-d_t$ = $VPartPerfSuff_t$

$VPartPerf-d_t+haben$ = $VPartPerfSuff_t$ $haben$

$VPartPerf-d_t+sein$ = $VPartPerfSuff_t$ $sein$

% getan
$VPartPerf_n$ = $VPartPerfSuff_n$

$VPartPerf_n+haben$ = $VPartPerfSuff_n$ $haben$

$VPartPerf_n+sein$ = $VPartPerfSuff_n$ $sein$

% downgecyclet
$VPartPerf-le$ = $VPartPerfSuff_t$

$VPartPerf-le+haben$ = $VPartPerfSuff_t$ $haben$

$VPartPerf-le+sein$ = $VPartPerfSuff_t$ $sein$

$VPartPerf-signen$ = $VPartPerfSuff_t$

$VPartPerf-signen+haben$ = $VPartPerfSuff_t$ $haben$

$VPartPerf-signen+sein$ = $VPartPerfSuff_t$ $sein$

% gefaked
$VPartPerf_ed$ = $VPartPerfSuff_ed$

$VPartPerf_ed+haben$ = $VPartPerfSuff_ed$ $haben$

$VPartPerf_ed+sein$ = $VPartPerfSuff_ed$ $sein$

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

$VPresIndPlSuff-signen$ = {<+V><1><Pl><Pres><Ind>}:{<SB>en} | \
                          {<+V><2><Pl><Pres><Ind>}:{<SB>t}  | \
                          {<+V><3><Pl><Pres><Ind>}:{<SB>en}

$VPresInd13PlSuff-sein$ = {<+V><1><Pl><Pres><Ind>}:{} | \
                          {<+V><3><Pl><Pres><Ind>}:{}

$VPresInd2PlSuff-sein$ = {<+V><2><Pl><Pres><Ind>}:{}

$VPresSubjSuff$ = {<+V><1><Sg><Pres><Subj>}:{<SB>e}   | \
                  {<+V><2><Sg><Pres><Subj>}:{<SB>est} | \
                  {<+V><3><Sg><Pres><Subj>}:{<SB>e}   | \
                  {<+V><1><Pl><Pres><Subj>}:{<SB>en}  | \
                  {<+V><2><Pl><Pres><Subj>}:{<SB>et}  | \
                  {<+V><3><Pl><Pres><Subj>}:{<SB>en}

$VPresSubjSuff-le$ = {<+V><1><Sg><Pres><Subj>}:{}       | \
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
$VPres-le$ = $VPresInd1SgSuff_0$  | \
             $VPresInd2SgSuff_st$ | \
             $VPresInd3SgSuff_t$  | \
             $VPresIndPlSuff-tun$ | \
             $VPresSubjSuff-le$

% fake, fakst, fakt, faken, fakt, faken
$VPres-ak-ik$ = $VPresInd1SgSuff_e$   | \
                $VPresInd2SgSuff_est$ | \
                $VPresInd3SgSuff_et$  | \
                $VPresIndPlSuff$      | \
                $VPresSubjSuff$

$VPres-signen$ = $VPresInd1SgSuff_e$     | \
                 $VPresInd2SgSuff_st$    | \
                 $VPresInd3SgSuff_t$     | \
                 $VPresIndPlSuff-signen$ | \
                 $VPresSubjSuff$

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

$VPast-le$ = $VPastIndWeakSuff_t$ | \
             $VPastSubjWeakSuff_t$

$VPast-signen$ = $VPastIndWeakSuff_t$ | \
                 $VPastSubjWeakSuff_t$

% dachte, dachtest, dachte, dachten, dachtet, dachten
% konnte, konntest, konnte, konnten, konntet, konnten
% wusste, wusstest, wusste, wussten, wusstet, wussten
$VPastIndWeak$ = $VPastIndWeakSuff_et$

% hatte, hattest, hatte, hatten, hattet, hatten
% sandte, sandtest, sandte, sandten, sandtet, sandten
$VPastInd-d-t_t$ = $VPastIndWeakSuff_t$

% downcyclete, downcycletest, downcyclete, downcycleten, downcycletet, downcycleten
$VPastInd-le$ = $VPastIndWeakSuff_t$

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
$VPastSubj-le$ = $VPastSubjWeakSuff_t$

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

$VImpPlSuff_et$ = {<+V><Imp><Pl>}:{<SB><ins(e)>t<rm|Imp>}

$VImpPlSuff_t$ = {<+V><Imp><Pl>}:{<SB>t<rm|Imp>}

$VImpPlSuff-sein$ = {<+V><Imp><Pl>}:{<rm|Imp>}

% sieh(e)
$VImpSg$ = $VImpSgSuff_0$ | \
           $VImpSgSuff_e$

% tu; sei
$VImpSg0$ = $VImpSgSuff_0$

$VImpSg-d-t$ = $VImpSgNonStSuff_0$ | \
               $VImpSgSuff_e$

$VImpSg-m-n$ = $VImpSgSuff_e$

$VImpSg-le$ = $VImpSgSuff_0$

$VImpSg-ak-ik$ = $VImpSgSuff_e$

% seht; tut
$VImpPl$ = $VImpPlSuff_et$

% seid
$VImpPl-sein$ = $VImpPlSuff-sein$

$VImpPl-signen$ = $VImpPlSuff_t$

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
$VImp-le$ = $VImpSg-le$ | \
            $VImpPl$

% fake
$VImp-ak-ik$ = $VImpSg-ak-ik$ | \
               $VImpPl$

$VImp-signen$ = $VImpSg$ | \
                $VImpPl-signen$

% lieben; spielen
$VWeak$ = $VInf$          | \
          $VPartPres$     | \
          $VPartPerfWeak$ | \
          $VPres$         | \
          $VPastWeak$     | \
          $VImp$

$VWeak+haben$ = $VInf$                | \
                $VPartPres$           | \
                $VPartPerfWeak+haben$ | \
                $VPres$               | \
                $VPastWeak$           | \
                $VImp$

$VWeak+sein$ = $VInf$               | \
               $VPartPres$          | \
               $VPartPerfWeak+sein$ | \
               $VPres$              | \
               $VPastWeak$          | \
               $VImp$

% arbeiten; reden
$VWeak-d-t$ = $VInf$          | \
              $VPartPres$     | \
              $VPartPerfWeak$ | \
              $VPres$         | \
              $VPastWeak$     | \
              $VImp-d-t$

$VWeak-d-t+haben$ = $VInf$                | \
                    $VPartPres$           | \
                    $VPartPerfWeak+haben$ | \
                    $VPres$               | \
                    $VPastWeak$           | \
                    $VImp-d-t$

$VWeak-d-t+sein$ = $VInf$               | \
                   $VPartPres$          | \
                   $VPartPerfWeak+sein$ | \
                   $VPres$              | \
                   $VPastWeak$          | \
                   $VImp-d-t$

% atmen; rechnen
$VWeak-m-n$ = $VInf$          | \
              $VPartPres$     | \
              $VPartPerfWeak$ | \
              $VPres-m-n$     | \
              $VPastWeak$     | \
              $VImp-m-n$

$VWeak-m-n+haben$ = $VInf$                | \
                    $VPartPres$           | \
                    $VPartPerfWeak+haben$ | \
                    $VPres-m-n$           | \
                    $VPastWeak$           | \
                    $VImp-m-n$

$VWeak-m-n+sein$ = $VInf$               | \
                   $VPartPres$          | \
                   $VPartPerfWeak+sein$ | \
                   $VPres-m-n$          | \
                   $VPastWeak$          | \
                   $VImp-m-n$

% küssen
$VWeak-s$ = $VInf$          | \
            $VPartPres$     | \
            $VPartPerfWeak$ | \
            $VPres-s$       | \
            $VPastWeak$     | \
            $VImp$

$VWeak-s+haben$ = $VInf$                | \
                  $VPartPres$           | \
                  $VPartPerfWeak+haben$ | \
                  $VPres-s$             | \
                  $VPastWeak$           | \
                  $VImp$

$VWeak-s+sein$ = $VInf$               | \
                 $VPartPres$          | \
                 $VPartPerfWeak+sein$ | \
                 $VPres-s$            | \
                 $VPastWeak$          | \
                 $VImp$

% segeln; rudern (cf. $SchwaTrigger$ in markers.fst)
$VWeak-el-er$ = $VInf-el-er$      | \
                $VPartPres-el-er$ | \
                $VPartPerfWeak$   | \
                $VPres-el-er$     | \
                $VPastWeak$       | \
                $VImp-el-er$

$VWeak-el-er+haben$ = $VInf-el-er$          | \
                      $VPartPres-el-er$     | \
                      $VPartPerfWeak+haben$ | \
                      $VPres-el-er$         | \
                      $VPastWeak$           | \
                      $VImp-el-er$

$VWeak-el-er+sein$ = $VInf-el-er$         | \
                     $VPartPres-el-er$    | \
                     $VPartPerfWeak+sein$ | \
                     $VPres-el-er$        | \
                     $VPastWeak$          | \
                     $VImp-el-er$

% recyclen
$VWeak-le$ = $VInf-le$      | \
             $VPartPres-le$ | \
             $VPartPerf-le$ | \
             $VPres-le$     | \
             $VPast-le$     | \
             $VImp-le$

$VWeak-le+haben$ = $VInf-le$            | \
                   $VPartPres-le$       | \
                   $VPartPerf-le+haben$ | \
                   $VPres-le$           | \
                   $VPast-le$           | \
                   $VImp-le$

$VWeak-le+sein$ = $VInf-le$           | \
                  $VPartPres-le$      | \
                  $VPartPerf-le+sein$ | \
                  $VPres-le$          | \
                  $VPast-le$          | \
                  $VImp-le$

% designen
$VWeak-signen$ = $VInf$             | \
                 $VPartPres$        | \
                 $VPartPerf-signen$ | \
                 $VPres-signen$     | \
                 $VPast-signen$     | \
                 $VImp-signen$

$VWeak-signen+haben$ = $VInf$                   | \
                       $VPartPres$              | \
                       $VPartPerf-signen+haben$ | \
                       $VPres-signen$           | \
                       $VPast-signen$           | \
                       $VImp-signen$

$VWeak-signen+sein$ = $VInf$                  | \
                      $VPartPres$             | \
                      $VPartPerf-signen+sein$ | \
                      $VPres-signen$          | \
                      $VPast-signen$          | \
                      $VImp-signen$

% faken; liken
$VWeak-ak-ik$ = $VInf$           | \
                $VPartPres$      | \
                $VPartPerfWeak$  | \
                $VPres-ak-ik$    | \
                $VPastWeak$      | \
                $VImp-ak-ik$

$VWeak-ak-ik+haben$ = $VInf$                | \
                      $VPartPres$           | \
                      $VPartPerfWeak+haben$ | \
                      $VPres-ak-ik$         | \
                      $VPastWeak$           | \
                      $VImp-ak-ik$

$VWeak-ak-ik+sein$ = $VInf$               | \
                     $VPartPres$          | \
                     $VPartPerfWeak+sein$ | \
                     $VPres-ak-ik$        | \
                     $VPastWeak$          | \
                     $VImp-ak-ik$


% adpositions

% unter
$Prep$ = {<+PREP>}:{}

% unterm
$Prep+Art-m$ = {<+PREPART><Masc><Dat><Sg>}:{} | \
               {<+PREPART><Neut><Dat><Sg>}:{}

$Prep+Art-m-NonSt$ = {<+PREPART><Masc><Dat><Sg><NonSt>}:{} | \
                     {<+PREPART><Neut><Dat><Sg><NonSt>}:{}

% untern
$Prep+Art-n-NonSt$ = {<+PREPART><Masc><Acc><Sg><NonSt>}:{} % cf. Duden-Grammatik (2016: § 928)

% unters
$Prep+Art-s$ = {<+PREPART><Neut><Acc><Sg>}:{}

% zur
$Prep+Art-r$ = {<+PREPART><Fem><Dat><Sg>}:{}

% zufolge, willen
$Postp$ = {<+POSTP>}:{}


% other words

% und
$ConjCoord$ = {<+CONJ><Coord>}:{}

% dass
$ConjSub$ = {<+CONJ><Sub>}:{}

% um
$ConjInfCl$ = {<+CONJ><InfCl>}:{}

% als
$ConjAdjComp$ = {<+CONJ><AdjComp>}:{}

% nicht
$PtclNeg$ = {<+PTCL><Neg>}:{}

% zu
$PtclAdjPos$ = {<+PTCL><AdjPos>}:{}

% am
$PtclAdjSup$ = {<+PTCL><AdjSup>}:{}

% zu
$PtclInfCl$ = {<+PTCL><InfCl>}:{}

% ein
$Prev$ = {<+PREV>}:{}

% hallo
$Intj$ = {<+INTJ>}:{}


% abbreviations

% Kfm. (= Kaufmann)
$AbbrNMasc$ = {<+NN><Masc><UnmCase><UnmNum>}:{}

% Gr. (= Gros)
$AbbrNNeut$ = {<+NN><Neut><UnmCase><UnmNum>}:{}

% Kffr. (= Kauffrau)
$AbbrNFem$ = {<+NN><Fem><UnmCase><UnmNum>}:{}

% Gebr. (= Gebrüder)
$AbbrNUnmGend$ = {<+NN><UnmGend><UnmCase><Pl>}:{}

% f. (= folgende)
$AbbrAdj$ = {<+ADJ><Pos><UnmFunc><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

% Ew. (= Euer)
$AbbrPoss$ = {<+POSS><Attr><UnmGend><UnmCase><UnmNum><UnmInfl>}:{}

% vgl. (= vergleiche)
$AbbrVImp$ = {<+V><Imp><UnmNum>}:{}


% inflection transducer

$INFL$ = <>:<AbbrAdj>                 $AbbrAdj$                | \
         <>:<AbbrNFem>                $AbbrNFem$               | \
         <>:<AbbrNMasc>               $AbbrNMasc$              | \
         <>:<AbbrNNeut>               $AbbrNNeut$              | \
         <>:<AbbrNUnmGend>            $AbbrNUnmGend$           | \
         <>:<AbbrPoss>                $AbbrPoss$               | \
         <>:<AbbrVImp>                $AbbrVImp$               | \
         <>:<Adj_er_$est>             $Adj_er_\$est$           | \
         <>:<Adj_er_$st>              $Adj_er_\$st$            | \
         <>:<Adj_er_est>              $Adj_er_est$             | \
         <>:<Adj_er_st>               $Adj_er_st$              | \
         <>:<AdjComp-el_er>           $AdjComp-el_er$          | \
         <>:<AdjComp-en_er>           $AdjComp-en_er$          | \
         <>:<AdjComp-er_er>           $AdjComp-er_er$          | \
         <>:<AdjComp0>                $AdjComp0$               | \
         <>:<AdjComp_er>              $AdjComp_er$             | \
         <>:<AdjPos>                  $AdjPos$                 | \
         <>:<AdjPos-e>                $AdjPos-e$               | \
         <>:<AdjPos-el>               $AdjPos-el$              | \
         <>:<AdjPos-en>               $AdjPos-en$              | \
         <>:<AdjPos-er>               $AdjPos-er$              | \
         <>:<AdjPos0>                 $AdjPos0$                | \
         <>:<AdjPos0-e>               $AdjPos0-e$              | \
         <>:<AdjPos0-viel>            $AdjPos0-viel$           | \
         <>:<AdjPosAttr>              $AdjPosAttr$             | \
         <>:<AdjPosAttr-er>           $AdjPosAttr-er$          | \
         <>:<AdjPosAttr-ler>          $AdjPosAttr-ler$         | \
         <>:<AdjPosAttr0>             $AdjPosAttr0$            | \
         <>:<AdjPosAttrSubst0>        $AdjPosAttrSubst0$       | \
         <>:<AdjPosPred>              $AdjPosPred$             | \
         <>:<AdjPosPred-e>            $AdjPosPred-e$           | \
         <>:<AdjSup_est>              $AdjSup_est$             | \
         <>:<AdjSup_st>               $AdjSup_st$              | \
         <>:<AdjSupAttr_est>          $AdjSupAttr_est$         | \
         <>:<AdjSupAttr_st>           $AdjSupAttr_st$          | \
         <>:<Adv>                     $Adv$                    | \
         <>:<AdvComp_er>              $AdvComp_er$             | \
         <>:<AdvComp0>                $AdvComp0$               | \
         <>:<AdvSup_est>              $AdvSup_est$             | \
         <>:<AdvSup_st>               $AdvSup_st$              | \
         <>:<ArtDef>                  $ArtDef$                 | \
         <>:<ArtDef-das+DemNeut>      $ArtDef-das+DemNeut$     | \
         <>:<ArtDef-dem+DemMasc>      $ArtDef-dem+DemMasc$     | \
         <>:<ArtDef-dem+DemNeut>      $ArtDef-dem+DemNeut$     | \
         <>:<ArtDef-den+DemMasc>      $ArtDef-den+DemMasc$     | \
         <>:<ArtDef-den+DemUnmGend>   $ArtDef-den+DemUnmGend$  | \
         <>:<ArtDef-der+DemFem>       $ArtDef-der+DemFem$      | \
         <>:<ArtDef-der+DemMasc>      $ArtDef-der+DemMasc$     | \
         <>:<ArtDef-der+DemUnmGend>   $ArtDef-der+DemUnmGend$  | \
         <>:<ArtDef-des+DemMasc>      $ArtDef-des+DemMasc$     | \
         <>:<ArtDef-des+DemNeut>      $ArtDef-des+DemNeut$     | \
         <>:<ArtDef-die+DemFem>       $ArtDef-die+DemFem$      | \
         <>:<ArtDef-die+DemUnmGend>   $ArtDef-die+DemUnmGend$  | \
         <>:<ArtIndef>                $ArtIndef$               | \
         <>:<ArtIndef-n>              $ArtIndef-n$             | \
         <>:<ArtNeg>                  $ArtNeg$                 | \
         <>:<Card0>                   $Card0$                  | \
         <>:<Card-ein>                $Card-ein$               | \
         <>:<Card-kein>               $Card-kein$              | \
         <>:<Card-sieben>             $Card-sieben$            | \
         <>:<Card-vier>               $Card-vier$              | \
         <>:<Card-zwei>               $Card-zwei$              | \
         <>:<ConjAdjComp>             $ConjAdjComp$            | \
         <>:<ConjCoord>               $ConjCoord$              | \
         <>:<ConjInfCl>               $ConjInfCl$              | \
         <>:<ConjSub>                 $ConjSub$                | \
         <>:<Dem>                     $Dem$                    | \
         <>:<Dem0>                    $Dem0$                   | \
         <>:<Dem-alldem>              $Dem-alldem$             | \
         <>:<Dem-dies>                $Dem-dies$               | \
         <>:<Dem-solch>               $Dem-solch$              | \
         <>:<DemDef>                  $DemDef$                 | \
         <>:<DigCard>                 $DigCard$                | \
         <>:<DigFrac>                 $DigFrac$                | \
         <>:<DigOrd>                  $DigOrd$                 | \
         <>:<Frac0>                   $Frac0$                  | \
         <>:<Indef0>                  $Indef0$                 | \
         <>:<Indef-all>               $Indef-all$              | \
         <>:<Indef-beid>              $Indef-beid$             | \
         <>:<Indef-ein>               $Indef-ein$              | \
         <>:<Indef-einig>             $Indef-einig$            | \
         <>:<Indef-irgendein>         $Indef-irgendein$        | \
         <>:<Indef-irgendwelch>       $Indef-irgendwelch$      | \
         <>:<Indef-jed>               $Indef-jed$              | \
         <>:<Indef-jeglich>           $Indef-jeglich$          | \
         <>:<Indef-kein>              $Indef-kein$             | \
         <>:<Indef-manch>             $Indef-manch$            | \
         <>:<Indef-mehrer>            $Indef-mehrer$           | \
         <>:<Indef-saemtlich>         $Indef-saemtlich$        | \
         <>:<Indef-welch>             $Indef-welch$            | \
         <>:<IPro-frau>               $IPro-frau$              | \
         <>:<IPro-jedefrau>           $IPro-jedefrau$          | \
         <>:<IPro-jederfrau>          $IPro-jederfrau$         | \
         <>:<IPro-jedermann>          $IPro-jedermann$         | \
         <>:<IPro-man>                $IPro-man$               | \
         <>:<IPro-unsereiner>         $IPro-unsereiner$        | \
         <>:<IPro-unsereins>          $IPro-unsereins$         | \
         <>:<IProMasc>                $IProMasc$               | \
         <>:<IProMascAccSg>           $IProMascAccSg$          | \
         <>:<IProMascDatSg>           $IProMascDatSg$          | \
         <>:<IProMascGenSg>           $IProMascGenSg$          | \
         <>:<IProMascNomSg>           $IProMascNomSg$          | \
         <>:<IProNeut>                $IProNeut$               | \
         <>:<IProNeutAccSg>           $IProNeutAccSg$          | \
         <>:<IProNeutDatSg>           $IProNeutDatSg$          | \
         <>:<IProNeutGenSg>           $IProNeutGenSg$          | \
         <>:<IProNeutNomSg>           $IProNeutNomSg$          | \
         <>:<Intj>                    $Intj$                   | \
         <>:<NameFem_0>               $NameFem_0$              | \
         <>:<NameFem_apos>            $NameFem_apos$           | \
         <>:<NameFem_s>               $NameFem_s$              | \
         <>:<NameMasc_0>              $NameMasc_0$             | \
         <>:<NameMasc_apos>           $NameMasc_apos$          | \
         <>:<NameMasc_es>             $NameMasc_es$            | \
         <>:<NameMasc_s>              $NameMasc_s$             | \
         <>:<NameNeut_0>              $NameNeut_0$             | \
         <>:<NameNeut_apos>           $NameNeut_apos$          | \
         <>:<NameNeut_es>             $NameNeut_es$            | \
         <>:<NameNeut_s>              $NameNeut_s$             | \
         <>:<NameUnmGend|Pl_0>        $NameUnmGend|Pl_0$       | \
         <>:<NameUnmGend|Pl_n>        $NameUnmGend|Pl_n$       | \
         <>:<NFem0>                   $NFem0$                  | \
         <>:<NFem-Adj>                $NFem-Adj$               | \
         <>:<NFem-in>                 $NFem-in$                | \
         <>:<NFem|Pl_0>               $NFem|Pl_0$              | \
         <>:<NFem|Sg_0>               $NFem|Sg_0$              | \
         <>:<NFem_0_$_n>              $NFem_0_\$_n$            | \
         <>:<NFem_0_$e_n>             $NFem_0_\$e_n$           | \
         <>:<NFem_0_$en_0>            $NFem_0_\$en_0$          | \
         <>:<NFem_0_0_0>              $NFem_0_0_0$             | \
         <>:<NFem_0_0_n>              $NFem_0_0_n$             | \
         <>:<NFem_0_a/e_0>            $NFem_0_a/e_0$           | \
         <>:<NFem_0_a/en_0>           $NFem_0_a/en_0$          | \
         <>:<NFem_0_e_0>              $NFem_0_e_0$             | \
         <>:<NFem_0_e_n>              $NFem_0_e_n$             | \
         <>:<NFem_0_e_n~ss>           $NFem_0_e_n~ss$          | \
         <>:<NFem_0_ans/anten_0>      $NFem_0_ans/anten_0$     | \
         <>:<NFem_0_anx/angen_0>      $NFem_0_anx/angen_0$     | \
         <>:<NFem_0_e/i_0>            $NFem_0_e/i_0$           | \
         <>:<NFem_0_en_0>             $NFem_0_en_0$            | \
         <>:<NFem_0_es_0>             $NFem_0_es_0$            | \
         <>:<NFem_0_es/en_0>          $NFem_0_es/en_0$         | \
         <>:<NFem_0_ex/eges_0>        $NFem_0_ex/eges_0$       | \
         <>:<NFem_0_is/en_0>          $NFem_0_is/en_0$         | \
         <>:<NFem_0_is/iden_0>        $NFem_0_is/iden_0$       | \
         <>:<NFem_0_is/ides_0>        $NFem_0_is/ides_0$       | \
         <>:<NFem_0_ix/ices_0>        $NFem_0_ix/ices_0$       | \
         <>:<NFem_0_ix/izen_0>        $NFem_0_ix/izen_0$       | \
         <>:<NFem_0_ix/izes_0>        $NFem_0_ix/izes_0$       | \
         <>:<NFem_0_n_0>              $NFem_0_n_0$             | \
         <>:<NFem_0_ien_0>            $NFem_0_ien_0$           | \
         <>:<NFem_0_nes_0>            $NFem_0_nes_0$           | \
         <>:<NFem_0_os/otes_0>        $NFem_0_os/otes_0$       | \
         <>:<NFem_0_ox/oces_0>        $NFem_0_ox/oces_0$       | \
         <>:<NFem_0_s_0>              $NFem_0_s_0$             | \
         <>:<NFem_n_n_0>              $NFem_n_n_0$             | \
         <>:<NMasc0_es>               $NMasc0_es$              | \
         <>:<NMasc0_s>                $NMasc0_s$               | \
         <>:<NMasc-Adj>               $NMasc-Adj$              | \
         <>:<NMasc|Pl_0>              $NMasc|Pl_0$             | \
         <>:<NMasc|Sg_0>              $NMasc|Sg_0$             | \
         <>:<NMasc|Sg_es>             $NMasc|Sg_es$            | \
         <>:<NMasc|Sg_ns>             $NMasc|Sg_ns$            | \
         <>:<NMasc|Sg_s>              $NMasc|Sg_s$             | \
         <>:<NMasc_0_$e_n>            $NMasc_0_\$e_n$          | \
         <>:<NMasc_0_0_0>             $NMasc_0_0_0$            | \
         <>:<NMasc_0_0_n>             $NMasc_0_0_n$            | \
         <>:<NMasc_0_a/en_0>          $NMasc_0_a/en_0$         | \
         <>:<NMasc_0_as/anten_0>      $NMasc_0_as/anten_0$     | \
         <>:<NMasc_0_e_n>             $NMasc_0_e_n$            | \
         <>:<NMasc_0_e_n~ss>          $NMasc_0_e_n~ss$         | \
         <>:<NMasc_0_e/i_0>           $NMasc_0_e/i_0$          | \
         <>:<NMasc_0_en_0>            $NMasc_0_en_0$           | \
         <>:<NMasc_0_ens/entes_0>     $NMasc_0_ens/entes_0$    | \
         <>:<NMasc_0_es/iden_0>       $NMasc_0_es/iden_0$      | \
         <>:<NMasc_0_es/ides_0>       $NMasc_0_es/ides_0$      | \
         <>:<NMasc_0_es_0>            $NMasc_0_es_0$           | \
         <>:<NMasc_0_ex/izes_0>       $NMasc_0_ex/izes_0$      | \
         <>:<NMasc_0_ix/izes_0>       $NMasc_0_ix/izes_0$      | \
         <>:<NMasc_0_i/en_0>          $NMasc_0_i/en_0$         | \
         <>:<NMasc_0_i_0>             $NMasc_0_i_0$            | \
         <>:<NMasc_0_is/es_0>         $NMasc_0_is/es_0$        | \
         <>:<NMasc_0_nen_0>           $NMasc_0_nen_0$          | \
         <>:<NMasc_0_o/en_0>          $NMasc_0_o/en_0$         | \
         <>:<NMasc_0_o/i_0>           $NMasc_0_o/i_0$          | \
         <>:<NMasc_0_os/en_0>         $NMasc_0_os/en_0$        | \
         <>:<NMasc_0_os/oden_0>       $NMasc_0_os/oden_0$      | \
         <>:<NMasc_0_os/oen_0>        $NMasc_0_os/oen_0$       | \
         <>:<NMasc_0_os/oi_0>         $NMasc_0_os/oi_0$        | \
         <>:<NMasc_0_s_0>             $NMasc_0_s_0$            | \
         <>:<NMasc_0_us/e_n>          $NMasc_0_us/e_n$         | \
         <>:<NMasc_0_us/een_0>        $NMasc_0_us/een_0$       | \
         <>:<NMasc_0_us/en_0>         $NMasc_0_us/en_0$        | \
         <>:<NMasc_0_us/er_n>         $NMasc_0_us/er_n$        | \
         <>:<NMasc_0_us/i_0>          $NMasc_0_us/i_0$         | \
         <>:<NMasc_0_us/ier_n>        $NMasc_0_us/ier_n$       | \
         <>:<NMasc_0_ynx/yngen_0>     $NMasc_0_ynx/yngen_0$    | \
         <>:<NMasc_en_en_0>           $NMasc_en_en_0$          | \
         <>:<NMasc_es_$e_n>           $NMasc_es_\$e_n$         | \
         <>:<NMasc_es_$er_n>          $NMasc_es_\$er_n$        | \
         <>:<NMasc_es_as/anten_0~ss>  $NMasc_es_as/anten_0~ss$ | \
         <>:<NMasc_es_e_n>            $NMasc_es_e_n$           | \
         <>:<NMasc_es_e_n~ss>         $NMasc_es_e_n~ss$        | \
         <>:<NMasc_es_en_0>           $NMasc_es_en_0$          | \
         <>:<NMasc_es_er_n>           $NMasc_es_er_n$          | \
         <>:<NMasc_es_es_0>           $NMasc_es_es_0$          | \
         <>:<NMasc_es_s_0>            $NMasc_es_s_0$           | \
         <>:<NMasc_es_ex/izes_0>      $NMasc_es_ex/izes_0$     | \
         <>:<NMasc_es_ix/izes_0>      $NMasc_es_ix/izes_0$     | \
         <>:<NMasc_es_us/een_0~ss>    $NMasc_es_us/een_0~ss$   | \
         <>:<NMasc_es_us/en_0~ss>     $NMasc_es_us/en_0~ss$    | \
         <>:<NMasc_es_us/i_0~ss>      $NMasc_es_us/i_0~ss$     | \
         <>:<NMasc_n_e/s_0>           $NMasc_n_e/s_0$          | \
         <>:<NMasc_n_n_0>             $NMasc_n_n_0$            | \
         <>:<NMasc_n_ns_0>            $NMasc_n_ns_0$           | \
         <>:<NMasc_ns_n_0>            $NMasc_ns_n_0$           | \
         <>:<NMasc_ns_$n_0>           $NMasc_ns_\$n_0$         | \
         <>:<NMasc_s_$_n>             $NMasc_s_\$_n$           | \
         <>:<NMasc_s_$e_n>            $NMasc_s_\$e_n$          | \
         <>:<NMasc_s_$er_n>           $NMasc_s_\$er_n$         | \
         <>:<NMasc_s_$_0>             $NMasc_s_\$_0$           | \
         <>:<NMasc_s_0_0>             $NMasc_s_0_0$            | \
         <>:<NMasc_s_0_n>             $NMasc_s_0_n$            | \
         <>:<NMasc_s_a/en_0>          $NMasc_s_a/en_0$         | \
         <>:<NMasc_s_e_n>             $NMasc_s_e_n$            | \
         <>:<NMasc_s_e/i_0>           $NMasc_s_e/i_0$          | \
         <>:<NMasc_s_er/res_0>        $NMasc_s_er/res_0$       | \
         <>:<NMasc_s_en_0>            $NMasc_s_en_0$           | \
         <>:<NMasc_s_er_n>            $NMasc_s_er_n$           | \
         <>:<NMasc_s_es_0>            $NMasc_s_es_0$           | \
         <>:<NMasc_s_i/en_0>          $NMasc_s_i/en_0$         | \
         <>:<NMasc_s_n_0>             $NMasc_s_n_0$            | \
         <>:<NMasc_s_ien_0>           $NMasc_s_ien_0$          | \
         <>:<NMasc_s_nen_0>           $NMasc_s_nen_0$          | \
         <>:<NMasc_s_o/en_0>          $NMasc_s_o/en_0$         | \
         <>:<NMasc_s_o/i_0>           $NMasc_s_o/i_0$          | \
         <>:<NMasc_s_s_0>             $NMasc_s_s_0$            | \
         <>:<NNeut0_es>               $NNeut0_es$              | \
         <>:<NNeut0_s>                $NNeut0_s$               | \
         <>:<NNeut-Adj>               $NNeut-Adj$              | \
         <>:<NNeut-Adj|Sg>            $NNeut-Adj|Sg$           | \
         <>:<NNeut-Inner>             $NNeut-Inner$            | \
         <>:<NNeut|Pl_0>              $NNeut|Pl_0$             | \
         <>:<NNeut|Pl_n>              $NNeut|Pl_n$             | \
         <>:<NNeut|Sg_0>              $NNeut|Sg_0$             | \
         <>:<NNeut|Sg_es>             $NNeut|Sg_es$            | \
         <>:<NNeut|Sg_es~ss>          $NNeut|Sg_es~ss$         | \
         <>:<NNeut|Sg_s>              $NNeut|Sg_s$             | \
         <>:<NNeut_0_0_0>             $NNeut_0_0_0$            | \
         <>:<NNeut_0_0_n>             $NNeut_0_0_n$            | \
         <>:<NNeut_0_a/ata_0>         $NNeut_0_a/ata_0$        | \
         <>:<NNeut_0_a/en_0>          $NNeut_0_a/en_0$         | \
         <>:<NNeut_0_ans/antien_0>    $NNeut_0_ans/antien_0$   | \
         <>:<NNeut_0_ans/anzien_0>    $NNeut_0_ans/anzien_0$   | \
         <>:<NNeut_0_e_n>             $NNeut_0_e_n$            | \
         <>:<NNeut_0_e_n~ss>          $NNeut_0_e_n~ss$         | \
         <>:<NNeut_0_e/i_0>           $NNeut_0_e/i_0$          | \
         <>:<NNeut_0_e/ia_0>          $NNeut_0_e/ia_0$         | \
         <>:<NNeut_0_e/ien_0>         $NNeut_0_e/ien_0$        | \
         <>:<NNeut_0_em/en_0>         $NNeut_0_em/en_0$        | \
         <>:<NNeut_0_en_0>            $NNeut_0_en_0$           | \
         <>:<NNeut_0_en/ina_0>        $NNeut_0_en/ina_0$       | \
         <>:<NNeut_0_ens/entia_0>     $NNeut_0_ens/entia_0$    | \
         <>:<NNeut_0_ens/entien_0>    $NNeut_0_ens/entien_0$   | \
         <>:<NNeut_0_ens/enzien_0>    $NNeut_0_ens/enzien_0$   | \
         <>:<NNeut_0_es_0>            $NNeut_0_es_0$           | \
         <>:<NNeut_0_ex/izia_0>       $NNeut_0_ex/izia_0$      | \
         <>:<NNeut_0_i/en_0>          $NNeut_0_i/en_0$         | \
         <>:<NNeut_0_nen_0>           $NNeut_0_nen_0$          | \
         <>:<NNeut_0_o/en_0>          $NNeut_0_o/en_0$         | \
         <>:<NNeut_0_o/i_0>           $NNeut_0_o/i_0$          | \
         <>:<NNeut_0_on/a_0>          $NNeut_0_on/a_0$         | \
         <>:<NNeut_0_on/en_0>         $NNeut_0_on/en_0$        | \
         <>:<NNeut_0_os/en_0>         $NNeut_0_os/en_0$        | \
         <>:<NNeut_0_s_0>             $NNeut_0_s_0$            | \
         <>:<NNeut_0_um/a_0>          $NNeut_0_um/a_0$         | \
         <>:<NNeut_0_um/en_0>         $NNeut_0_um/en_0$        | \
         <>:<NNeut_0_us/en_0>         $NNeut_0_us/en_0$        | \
         <>:<NNeut_0_us/era_0>        $NNeut_0_us/era_0$       | \
         <>:<NNeut_0_us/ora_0>        $NNeut_0_us/ora_0$       | \
         <>:<NNeut_ens_en_0>          $NNeut_ens_en_0$         | \
         <>:<NNeut_es_$e_n>           $NNeut_es_\$e_n$         | \
         <>:<NNeut_es_$er_n>          $NNeut_es_\$er_n$        | \
         <>:<NNeut_es_e_n>            $NNeut_es_e_n$           | \
         <>:<NNeut_es_e_n~ss>         $NNeut_es_e_n~ss$        | \
         <>:<NNeut_es_e_n~zz>         $NNeut_es_e_n~zz$        | \
         <>:<NNeut_es_en_0>           $NNeut_es_en_0$          | \
         <>:<NNeut_es_er_n>           $NNeut_es_er_n$          | \
         <>:<NNeut_es_es_0>           $NNeut_es_es_0$          | \
         <>:<NNeut_es_ex/izia_0>      $NNeut_es_ex/izia_0$     | \
         <>:<NNeut_es_ien_0>          $NNeut_es_ien_0$         | \
         <>:<NNeut_es_s_0>            $NNeut_es_s_0$           | \
         <>:<NNeut_s_$_n>             $NNeut_s_\$_n$           | \
         <>:<NNeut_s_$er_n>           $NNeut_s_\$er_n$         | \
         <>:<NNeut_s_0_n>             $NNeut_s_0_n$            | \
         <>:<NNeut_s_a_0>             $NNeut_s_a_0$            | \
         <>:<NNeut_s_a/ata_0>         $NNeut_s_a/ata_0$        | \
         <>:<NNeut_s_a/en_0>          $NNeut_s_a/en_0$         | \
         <>:<NNeut_s_e_n>             $NNeut_s_e_n$            | \
         <>:<NNeut_s_e/i_0>           $NNeut_s_e/i_0$          | \
         <>:<NNeut_s_e/ia_0>          $NNeut_s_e/ia_0$         | \
         <>:<NNeut_s_e/ien_0>         $NNeut_s_e/ien_0$        | \
         <>:<NNeut_s_em/en_0>         $NNeut_s_em/en_0$        | \
         <>:<NNeut_s_en_0>            $NNeut_s_en_0$           | \
         <>:<NNeut_s_en/ina_0>        $NNeut_s_en/ina_0$       | \
         <>:<NNeut_s_i/en_0>          $NNeut_s_i/en_0$         | \
         <>:<NNeut_s_ien_0>           $NNeut_s_ien_0$          | \
         <>:<NNeut_s_n_0>             $NNeut_s_n_0$            | \
         <>:<NNeut_s_nen_0>           $NNeut_s_nen_0$          | \
         <>:<NNeut_s_o/en_0>          $NNeut_s_o/en_0$         | \
         <>:<NNeut_s_o/i_0>           $NNeut_s_o/i_0$          | \
         <>:<NNeut_s_on/a_0>          $NNeut_s_on/a_0$         | \
         <>:<NNeut_s_on/en_0>         $NNeut_s_on/en_0$        | \
         <>:<NNeut_s_s_0>             $NNeut_s_s_0$            | \
         <>:<NNeut_s_um/a_0>          $NNeut_s_um/a_0$         | \
         <>:<NNeut_s_um/en_0>         $NNeut_s_um/en_0$        | \
         <>:<NNeut_s_0_0>             $NNeut_s_0_0$            | \
         <>:<NUnmGend|Pl_0>           $NUnmGend|Pl_0$          | \
         <>:<NUnmGend|Pl_n>           $NUnmGend|Pl_n$          | \
         <>:<Ord>                     $Ord$                    | \
         <>:<Poss>                    $Poss$                   | \
         <>:<Poss-er>                 $Poss-er$                | \
         <>:<Poss|Wk>                 $Poss|Wk$                | \
         <>:<Poss|Wk-er>              $Poss|Wk-er$             | \
         <>:<Postp>                   $Postp$                  | \
         <>:<PPro1AccPl>              $PPro1AccPl$             | \
         <>:<PPro1AccSg>              $PPro1AccSg$             | \
         <>:<PPro1DatPl>              $PPro1DatPl$             | \
         <>:<PPro1DatSg>              $PPro1DatSg$             | \
         <>:<PPro1GenPl>              $PPro1GenPl$             | \
         <>:<PPro1GenSg>              $PPro1GenSg$             | \
         <>:<PPro1NomPl>              $PPro1NomPl$             | \
         <>:<PPro1NomSg>              $PPro1NomSg$             | \
         <>:<PPro2AccPl>              $PPro2AccPl$             | \
         <>:<PPro2AccSg>              $PPro2AccSg$             | \
         <>:<PPro2DatPl>              $PPro2DatPl$             | \
         <>:<PPro2DatSg>              $PPro2DatSg$             | \
         <>:<PPro2GenPl>              $PPro2GenPl$             | \
         <>:<PPro2GenSg>              $PPro2GenSg$             | \
         <>:<PPro2NomPl>              $PPro2NomPl$             | \
         <>:<PPro2NomSg>              $PPro2NomSg$             | \
         <>:<PProFemAccSg>            $PProFemAccSg$           | \
         <>:<PProFemDatSg>            $PProFemDatSg$           | \
         <>:<PProFemGenSg>            $PProFemGenSg$           | \
         <>:<PProFemNomSg>            $PProFemNomSg$           | \
         <>:<PProMascAccSg>           $PProMascAccSg$          | \
         <>:<PProMascDatSg>           $PProMascDatSg$          | \
         <>:<PProMascGenSg>           $PProMascGenSg$          | \
         <>:<PProMascNomSg>           $PProMascNomSg$          | \
         <>:<PProNeutAccSg>           $PProNeutAccSg$          | \
         <>:<PProNeutAccSg-s>         $PProNeutAccSg-s$        | \
         <>:<PProNeutDatSg>           $PProNeutDatSg$          | \
         <>:<PProNeutGenSg>           $PProNeutGenSg$          | \
         <>:<PProNeutNomSg>           $PProNeutNomSg$          | \
         <>:<PProNeutNomSg-s>         $PProNeutNomSg-s$        | \
         <>:<PProUnmGendAccPl>        $PProUnmGendAccPl$       | \
         <>:<PProUnmGendDatPl>        $PProUnmGendDatPl$       | \
         <>:<PProUnmGendGenPl>        $PProUnmGendGenPl$       | \
         <>:<PProUnmGendNomPl>        $PProUnmGendNomPl$       | \
         <>:<PRecPl>                  $PRecPl$                 | \
         <>:<PRefl1AccSg>             $PRefl1AccSg$            | \
         <>:<PRefl1DatSg>             $PRefl1DatSg$            | \
         <>:<PRefl2AccSg>             $PRefl2AccSg$            | \
         <>:<PRefl2DatSg>             $PRefl2DatSg$            | \
         <>:<PRefl1Pl>                $PRefl1Pl$               | \
         <>:<PRefl2Pl>                $PRefl2Pl$               | \
         <>:<PRefl3>                  $PRefl3$                 | \
         <>:<Prep>                    $Prep$                   | \
         <>:<Prep+Art-m>              $Prep+Art-m$             | \
         <>:<Prep+Art-m-NonSt>        $Prep+Art-m-NonSt$       | \
         <>:<Prep+Art-n-NonSt>        $Prep+Art-n-NonSt$       | \
         <>:<Prep+Art-r>              $Prep+Art-r$             | \
         <>:<Prep+Art-s>              $Prep+Art-s$             | \
         <>:<Prev>                    $Prev$                   | \
         <>:<ProAdv>                  $ProAdv$                 | \
         <>:<PtclAdjPos>              $PtclAdjPos$             | \
         <>:<PtclAdjSup>              $PtclAdjSup$             | \
         <>:<PtclInfCl>               $PtclInfCl$              | \
         <>:<PtclNeg>                 $PtclNeg$                | \
         <>:<Rel>                     $Rel$                    | \
         <>:<Rel-welch>               $Rel-welch$              | \
         <>:<RProMascAccSg>           $RProMascAccSg$          | \
         <>:<RProMascDatSg>           $RProMascDatSg$          | \
         <>:<RProMascGenSg>           $RProMascGenSg$          | \
         <>:<RProMascNomSg>           $RProMascNomSg$          | \
         <>:<RProNeutAccSg>           $RProNeutAccSg$          | \
         <>:<RProNeutDatSg>           $RProNeutDatSg$          | \
         <>:<RProNeutGenSg>           $RProNeutGenSg$          | \
         <>:<RProNeutNomSg>           $RProNeutNomSg$          | \
         <>:<Roman>                   $Roman$                  | \
         <>:<VImp>                    $VImp$                   | \
         <>:<VImp-ak-ik>              $VImp-ak-ik$               | \
         <>:<VImp-d-t>                $VImp-d-t$               | \
         <>:<VImp-el-er>              $VImp-el-er$             | \
         <>:<VImp-le>                 $VImp-le$                | \
         <>:<VImp-m-n>                $VImp-m-n$               | \
         <>:<VImpPl>                  $VImpPl$                 | \
         <>:<VImpPl-sein>             $VImpPl-sein$            | \
         <>:<VImpSg>                  $VImpSg$                 | \
         <>:<VImpSg0>                 $VImpSg0$                | \
         <>:<VInf>                    $VInf$                   | \
         <>:<VInf-el-er>              $VInf-el-er$             | \
         <>:<VInf-le>                 $VInf-le$                | \
         <>:<VInf_n>                  $VInf_n$                 | \
         <>:<VModPresIndSg>           $VModPresIndSg$          | \
         <>:<VModPresNonIndSg>        $VModPresNonIndSg$       | \
         <>:<VPartPerf-d_t>           $VPartPerf-d_t$          | \
         <>:<VPartPerf-d_t><>:<haben> $VPartPerf-d_t+haben$    | \
         <>:<VPartPerf-d_t><>:<sein>  $VPartPerf-d_t+sein$     | \
         <>:<VPartPerf-le>            $VPartPerf-le$           | \
         <>:<VPartPerf-le><>:<haben>  $VPartPerf-le+haben$     | \
         <>:<VPartPerf-le><>:<sein>   $VPartPerf-le+sein$      | \
         <>:<VPartPerf_ed>            $VPartPerf_ed$           | \
         <>:<VPartPerf_ed><>:<haben>  $VPartPerf_ed+haben$     | \
         <>:<VPartPerf_ed><>:<sein>   $VPartPerf_ed+sein$      | \
         <>:<VPartPerf_n>             $VPartPerf_n$            | \
         <>:<VPartPerf_n><>:<haben>   $VPartPerf_n+haben$      | \
         <>:<VPartPerf_n><>:<sein>    $VPartPerf_n+sein$       | \
         <>:<VPartPerfStr>            $VPartPerfStr$           | \
         <>:<VPartPerfStr><>:<haben>  $VPartPerfStr+haben$     | \
         <>:<VPartPerfStr><>:<sein>   $VPartPerfStr+sein$      | \
         <>:<VPartPerfWeak>           $VPartPerfWeak$          | \
         <>:<VPartPerfWeak><>:<haben> $VPartPerfWeak+haben$    | \
         <>:<VPartPerfWeak><>:<sein>  $VPartPerfWeak+sein$     | \
         <>:<VPartPres>               $VPartPres$              | \
         <>:<VPartPres-el-er>         $VPartPres-el-er$        | \
         <>:<VPartPres-le>            $VPartPres-le$           | \
         <>:<VPastInd-d-t_t>          $VPastInd-d-t_t$         | \
         <>:<VPastInd-le>             $VPastInd-le$            | \
         <>:<VPastInd-werden>         $VPastInd-werden$        | \
         <>:<VPastIndPl-werden>       $VPastIndPl-werden$      | \
         <>:<VPastIndSg-ward>         $VPastIndSg-ward$        | \
         <>:<VPastIndStr>             $VPastIndStr$            | \
         <>:<VPastIndStr-s>           $VPastIndStr-s$          | \
         <>:<VPastIndWeak>            $VPastIndWeak$           | \
         <>:<VPastStr>                $VPastStr$               | \
         <>:<VPastStr-s>              $VPastStr-s$             | \
         <>:<VPastSubj-haben>         $VPastSubj-haben$        | \
         <>:<VPastSubj-le>            $VPastSubj-le$           | \
         <>:<VPastSubj2-sein>         $VPastSubj2-sein$        | \
         <>:<VPastSubjOld>            $VPastSubjOld$           | \
         <>:<VPastSubjStr>            $VPastSubjStr$           | \
         <>:<VPastSubjWeak>           $VPastSubjWeak$          | \
         <>:<VPres>                   $VPres$                  | \
         <>:<VPres-ak-ik>             $VPres-ak-ik$            | \
         <>:<VPres-el-er>             $VPres-el-er$            | \
         <>:<VPres-le>                $VPres-le$               | \
         <>:<VPres-m-n>               $VPres-m-n$              | \
         <>:<VPres-s>                 $VPres-s$                | \
         <>:<VPres-tun>               $VPres-tun$              | \
         <>:<VPresInd13Pl-sein>       $VPresInd13Pl-sein$      | \
         <>:<VPresInd1Sg-sein>        $VPresInd1Sg-sein$       | \
         <>:<VPresInd23Sg>            $VPresInd23Sg$           | \
         <>:<VPresInd23Sg-d_t>        $VPresInd23Sg-d_t$       | \
         <>:<VPresInd23Sg-t_0>        $VPresInd23Sg-t_0$       | \
         <>:<VPresInd2Pl-sein>        $VPresInd2Pl-sein$       | \
         <>:<VPresInd2Sg-sein>        $VPresInd2Sg-sein$       | \
         <>:<VPresInd2Sg-werden>      $VPresInd2Sg-werden$     | \
         <>:<VPresInd3Sg-sein>        $VPresInd3Sg-sein$       | \
         <>:<VPresInd3Sg-werden>      $VPresInd3Sg-werden$     | \
         <>:<VPresNonInd23Sg>         $VPresNonInd23Sg$        | \
         <>:<VPresSubj-sein>          $VPresSubj-sein$         | \
         <>:<VWeak>                   $VWeak$                  | \
         <>:<VWeak><>:<haben>         $VWeak+haben$            | \
         <>:<VWeak><>:<sein>          $VWeak+sein$             | \
         <>:<VWeak-ak-ik>             $VWeak-ak-ik$            | \
         <>:<VWeak-ak-ik><>:<haben>   $VWeak-ak-ik+haben$      | \
         <>:<VWeak-ak-ik><>:<sein>    $VWeak-ak-ik+sein$       | \
         <>:<VWeak-d-t>               $VWeak-d-t$              | \
         <>:<VWeak-d-t><>:<haben>     $VWeak-d-t+haben$        | \
         <>:<VWeak-d-t><>:<sein>      $VWeak-d-t+sein$         | \
         <>:<VWeak-el-er>             $VWeak-el-er$            | \
         <>:<VWeak-el-er><>:<haben>   $VWeak-el-er+haben$      | \
         <>:<VWeak-el-er><>:<sein>    $VWeak-el-er+sein$       | \
         <>:<VWeak-le>                $VWeak-le$               | \
         <>:<VWeak-le><>:<haben>      $VWeak-le+haben$         | \
         <>:<VWeak-le><>:<sein>       $VWeak-le+sein$          | \
         <>:<VWeak-m-n>               $VWeak-m-n$              | \
         <>:<VWeak-m-n><>:<haben>     $VWeak-m-n+haben$        | \
         <>:<VWeak-m-n><>:<sein>      $VWeak-m-n+sein$         | \
         <>:<VWeak-s>                 $VWeak-s$                | \
         <>:<VWeak-s><>:<haben>       $VWeak-s+haben$          | \
         <>:<VWeak-s><>:<sein>        $VWeak-s+sein$           | \
         <>:<VWeak-signen>            $VWeak-signen$           | \
         <>:<VWeak-signen><>:<haben>  $VWeak-signen+haben$     | \
         <>:<VWeak-signen><>:<sein>   $VWeak-signen+sein$      | \
         <>:<WAdv>                    $WAdv$                   | \
         <>:<W-welch>                 $W-welch$                | \
         <>:<WProMascAccSg>           $WProMascAccSg$          | \
         <>:<WProMascDatSg>           $WProMascDatSg$          | \
         <>:<WProMascGenSg>           $WProMascGenSg$          | \
         <>:<WProMascNomSg>           $WProMascNomSg$          | \
         <>:<WProNeutAccSg>           $WProNeutAccSg$          | \
         <>:<WProNeutDatSg>           $WProNeutDatSg$          | \
         <>:<WProNeutGenSg>           $WProNeutGenSg$          | \
         <>:<WProNeutNomSg>           $WProNeutNomSg$


% inflection filter

ALPHABET = [#char# #surface-trigger# #orth-trigger# #phon-trigger# \
            #morph-trigger# #boundary-trigger# <ge>]

$=INFL$ = [#inflection#]:<>

$=AUX$ = [#auxiliary#]:<>

$InflFilter$ = (.* $=INFL$ $=AUX$ $=INFL$ $=AUX$ .*) | \
               (.* $=INFL$ $=INFL$ .*)
