options(warn = 2)# warnings are errors here
pdf("p-qbeta-strict-tst.pdf")
.pt <- proc.time()

## The relative error typically returned by all.equal.numeric()
## "as simple as possible" -- should work also for 'Matrix' etc ==> no mean() ..
relErr <- function(target, current) {
    n <- length(current)
    if(length(target) < n) target <- rep_len(target, n)
    sum(abs(target - current)) / sum(abs(target))
}
lseq <- function(from, to, length) ## purpose: equidistant on log scale
    2^seq(log2(from), log2(to), length.out = length)


a <- 25; b <- 6
x <- 2^-(300:200)
if(interactive() && require(Rmpfr)) {
    pbi <- pbetaI(x, a,b, log.p=TRUE, precBits = 2048)
    ## plus experiments, to see that 2048 bits are way enough ...
    dput(format(roundMpfr(pbi, 64))) ##
} ## plus manual editing, removing all  ' " ' :

lpb <- c(
-5186.73671481652222237, -5169.40803530252358966, -5152.07935578852495651,
-5134.75067627452632379, -5117.42199676052769108, -5100.09331724652905837,
-5082.76463773253042566, -5065.43595821853179295, -5048.10727870453316024,
-5030.77859919053452753, -5013.44991967653589482, -4996.12124016253726211,
-4978.79256064853862940, -4961.46388113453999669, -4944.13520162054136398,
-4926.80652210654273127, -4909.47784259254409855, -4892.14916307854546584,
-4874.82048356454683313, -4857.49180405054820042, -4840.16312453654956727,
-4822.83444502255093456, -4805.50576550855230185, -4788.17708599455366913,
-4770.84840648055503642, -4753.51972696655640371, -4736.19104745255777100,
-4718.86236793855913829, -4701.53368842456050558, -4684.20500891056187287,
-4666.87632939656324016, -4649.54764988256460745, -4632.21897036856597474,
-4614.89029085456734203, -4597.56161134056870932, -4580.23293182657007661,
-4562.90425231257144389, -4545.57557279857281118, -4528.24689328457417803,
-4510.91821377057554532, -4493.58953425657691261, -4476.26085474257827990,
-4458.93217522857964719, -4441.60349571458101448, -4424.27481620058238176,
-4406.94613668658374905, -4389.61745717258511634, -4372.28877765858648363,
-4354.96009814458785092, -4337.63141863058921821, -4320.30273911659058550,
-4302.97405960259195279, -4285.64538008859332008, -4268.31670057459468737,
-4250.98802106059605466, -4233.65934154659742195, -4216.33066203259878879,
-4199.00198251860015608, -4181.67330300460152337, -4164.34462349060289066,
-4147.01594397660425795, -4129.68726446260562524, -4112.35858494860699253,
-4095.02990543460835982, -4077.70122592060972710, -4060.37254640661109439,
-4043.04386689261246168, -4025.71518737861382897, -4008.38650786461519626,
-3991.05782835061656333, -3973.72914883661793062, -3956.40046932261929791,
-3939.07178980862066520, -3921.74311029462203249, -3904.41443078062339977,
-3887.08575126662476706, -3869.75707175262613435, -3852.42839223862750164,
-3835.09971272462886871, -3817.77103321063023600, -3800.44235369663160329,
-3783.11367418263297058, -3765.78499466863433787, -3748.45631515463570516,
-3731.12763564063707245, -3713.79895612663843973, -3696.47027661263980702,
-3679.14159709864117409, -3661.81291758464254138, -3644.48423807064390867,
-3627.15555855664527596, -3609.82687904264664325, -3592.49819952864801054,
-3575.16952001464937783, -3557.84084050065074512, -3540.51216098665211240,
-3523.18348147265347947, -3505.85480195865484676, -3488.52612244465621405,
-3471.19744293065758134, -3453.86876341665894863)
stopifnot( all.equal(lpb, pbeta(x,a,b,log.=TRUE), tol=2e-16) )# pbeta() check


qpb <- qbeta(lpb, a,b, log.p=TRUE)
stopifnot(qpb > 0)# ok R >= 3.2.0, not in R 3.1.x
## ideally   x == qbeta(pbeta(x, *), *) :
all.equal(x, qpb, tol=0)# now 4.5666e-15; was 5.238e-15, then 4.986e-15
(relE <- relErr(x, qpb)) # 4.5666e-15
stopifnot(relE < 4e-14)

## a less extreme set -- but which uses *many* Newton iterations in qbeta()
a <- 25; b <- 6
x1 <- 2^-((20:120)/8)
if(interactive() && require(Rmpfr)) {
    pbi <- pbetaI(x, a,b, log.p=TRUE, precBits = 2048)
    ## plus experiments, to see that 2048 bits are way enough ...
    dput(format(roundMpfr(pbi, 64))) ##
} ## plus manual editing, removing all  ' " ' :

lp1 <- c(
-32.3854423368776834953, -34.4673775119354555037, -36.5575116684945878344,
-38.6549408996236989744, -40.7588797271766572448, -42.8686422494639326058,
-44.9836268805878782655, -47.1033038887113481505, -49.2272051373989160267,
-51.3549155771523890938, -53.4860661393789178081, -55.6203277631858045461,
-57.7574063441183625303, -59.8970384385116822318, -62.0389875912418167943,
-64.1830411810069771730, -66.3290076977781794185, -68.4767143831449023872,
-70.6260051769883206996, -72.7767389240201063513, -74.9287878018119846216,
-77.0820359384527194757, -79.2363781932417950496, -81.3917190781217361681,
-83.5479718010642398301, -85.7050574155147660699, -87.8629040623880331051,
-90.0214462930893329073, -92.1806244636893542185, -94.3403841917643962364,
-96.5006758685776125997, -98.6614542202591991785, -100.822677912475871277,
-102.984309193787888156, -105.146313573496065365, -107.308659530298884925,
-109.471318248524419364, -111.634263379085354198, -113.797470822637087941,
-115.960918532706589869, -118.124586336810151355, -120.288455773796669625,
-122.452509945844263323, -124.616733383705931573, -126.781111923947395655,
-128.945632597050500942, -131.110283525370608940, -133.275053830038264766,
-135.439933545985967511, -137.604913544361364852, -139.769985461659902712,
-141.935141634974191005, -144.100375042814531426, -146.265679251006534833,
-148.431048363217896496, -150.596476975707801879, -152.761960135929819787,
-154.927493304652777115, -157.093072321294422056, -159.258693372190260479,
-161.424352961544612370, -163.590047884833502595, -165.755775204449382204,
-167.921532227396093043, -170.087316484859319879, -172.253125713493005638,
-174.418957838276008993, -176.584810956806029708, -178.750683324909148353,
-180.916573343453874659, -183.082479546268141732, -185.248400589066309921,
-187.414335239301226746, -189.580282366863611607, -191.746240935557583460,
-193.912209995287317457, -196.078188674895169383, -198.244176175596733075,
-200.410171764962911981, -202.576174771403232380, -204.742184579108529904,
-206.908200623414650632, -209.074222386551973982, -211.240249393748649162,
-213.406281209657976525, -215.572317435082926512, -217.738357703973061677,
-219.904401680671135980, -222.070449057388595873, -224.236499551890932400,
-226.402552905375368947, -228.568608880524961821, -230.734667259724367416,
-232.900727843423843350, -235.066790448639183389, -237.232854907576249937,
-239.398921066369763294, -241.564988783926857030, -243.731057930866643141,
-245.897128388547890981, -248.063200048177428608)
stopifnot( all.equal(lp1, pbeta(x1,a,b,log.=TRUE), tol=2e-16) )# pbeta() check

qp1 <- qbeta(lp1, a,b, log.p=TRUE)
stopifnot(qp1 > 0)
## ideally   x == qbeta(pbeta(x, *), *) :
relErr(x1, qp1)# now 2.077e-16, was 2.99e-16
relE <- 1 - qp1/x1
stopifnot(print(mean(abs(relE))) < 3e-15, # 5.331e-16; was 6.0897e-16, then 5.4632e-16
	  print(max (abs(relE))) < 1e-14) # 1.776e-15

## log.p=FALSE: --- here (with DEBUG_qbeta), see number of Newton steps
p1 <- exp(lp1)
qp1. <- qbeta(p1, a,b)
## --> many cases that need "too many" Newton steps (on x0 scale: rather use log(x)-scale!)
## TODO? maybe change log_q_cut = -5 to ~ -2 (for this example; it really should depend on (a,b) ..

relE. <- 1 - qp1./x1
stopifnot(all.equal(qp1, qp1., tol=8*.Machine$double.eps),
	  print(mean(abs(relE.))) < 2e-15,  # 3.9023e-16 was 3.9572e-16,  4.0781e-16
	  print(max (abs(relE.))) < 7e-15 ) # 1.1102e-15; was 1.3323e-15
proc.time() - .pt; .pt <- proc.time()


a <- 43779; b <- 0.06728; x <- -exp(901/256)
(qx <- qbeta(x , a,b, log=TRUE)) ## now 3 N iter. in x-scale; had 157 iter. in log_x scale
## 0.9993614
(pq <- pbeta(qx, a,b, log=TRUE)) ## = -33.7686
stopifnot(print(abs(1 - pq/x)) < 1e-15) # rel.err ~  8.88e-16 "perfect"
## but it uses probably the wrong swap_tail decision...
curve(pbeta(exp(x), a,b, log=TRUE), -1e-3, -1e-7,   n=1025) # "the same" as
par(new=TRUE)
curve(pbeta(  x,    a,b, log=TRUE), 0.999, 1-1e-7, col=2, ylab="", xaxt="n"); axis(3)
abline(v = qx, h = x, col="light blue", lty = 2); mtext(line=-1, sprintf("(a=%g, b=%g)",a,b))

## as is this one -- the mirror image:
(x. <- log1p(-exp(x))) #  -2.160156e-15
(q. <- qbeta(x., b,a, log=TRUE, lower.tail=FALSE))# very quick convergence: u0 is perfect
## 1.425625e-223
(p. <- pbeta(q., b,a, log=TRUE, lower.tail=FALSE))
stopifnot(all.equal(p., x., tol = 1e-15))

## very different picture at the *other tail*:
(q2 <- qbeta(x., b,a, log=TRUE)) ## 0.0006386087
stopifnot(all.equal(x., pbeta(q2, b,a, log=TRUE), tol= 1e-13)) # Lx 64b: 2.37e-15

curve(pbeta(x, b,a, log=TRUE), 1e-30, .5, n=1025, log="x")
# Flip vertically and use log scale ==> "close" to  -x. = 2.160156e-15
curve(-pbeta(x, b,a, log=TRUE), 1e-8, .005, n=1025, log="xy")
abline(v = q2, h = -x., lty=3, col=2)

### more extreme (a,b) [still computable with Rmpfr pbetaI():]
a <- 800; b <- 2
x <- 2^-c(10*(100:4), 37, 2*(17:14), 27:2, (8:1)/8)
curve(pbeta(x,a,b, log=TRUE), n=1025, log="x", 1e-200, .1); mtext(R.version.string)
axis(1, at=0.1, padj=-1); abline(h=0, v=.1, lty=2); mtext(line=-1, sprintf("(a=%g, b=%g)",a,b))

if(interactive() && require(Rmpfr)) {
    pbi <- pbetaI(x, a,b, log.p=TRUE, precBits = 2048)
    ## plus experiments, to see that 2048 bits are way enough ...
    dput(format(roundMpfr(pbi, 64))) ##
    stopifnot( all.equal(pbi, pbeta(x,a,b,log.=TRUE), tol=2e-16) )
} ## plus manual editing, removing all  ' " ' :

lp2 <- c(-554511.058587009179178, -548965.881142529616682, -543420.703698050054243,
-537875.526253570491747, -532330.348809090929251, -526785.171364611366812,
-521239.993920131804316, -515694.816475652241849, -510149.639031172679381,
-504604.461586693116885, -499059.284142213554418, -493514.106697733991950,
-487968.929253254429483, -482423.751808774866987, -476878.574364295304520,
-471333.396919815742052, -465788.219475336179556, -460243.042030856617089,
-454697.864586377054621, -449152.687141897492154, -443607.509697417929658,
-438062.332252938367191, -432517.154808458804723, -426971.977363979242256,
-421426.799919499679760, -415881.622475020117292, -410336.445030540554825,
-404791.267586060992329, -399246.090141581429862, -393700.912697101867394,
-388155.735252622304927, -382610.557808142742431, -377065.380363663179963,
-371520.202919183617496, -365975.025474704055000, -360429.848030224492533,
-354884.670585744930065, -349339.493141265367598, -343794.315696785805102,
-338249.138252306242634, -332703.960807826680167, -327158.783363347117700,
-321613.605918867555204, -316068.428474387992736, -310523.251029908430269,
-304978.073585428867773, -299432.896140949305305, -293887.718696469742838,
-288342.541251990180371, -282797.363807510617875, -277252.186363031055407,
-271707.008918551492940, -266161.831474071930444, -260616.654029592367976,
-255071.476585112805509, -249526.299140633243027, -243981.121696153680560,
-238435.944251674118078, -232890.766807194555611, -227345.589362714993129,
-221800.411918235430647, -216255.234473755868180, -210710.057029276305698,
-205164.879584796743231, -199619.702140317180749, -194074.524695837618282,
-188529.347251358055800, -182984.169806878493333, -177438.992362398930851,
-171893.814917919368369, -166348.637473439805902, -160803.460028960243420,
-155258.282584480680953, -149713.105140001118471, -144167.927695521556004,
-138622.750251041993522, -133077.572806562431055, -127532.395362082868573,
-121987.217917603306098, -116442.040473123743624, -110896.863028644181149,
-105351.685584164618675, -99806.5081396850562001, -94261.3306952054937184,
-88716.1532507259312439, -83170.9758062463687693, -77625.7983617668062948,
-72080.6209172872438202, -66535.4434728076813457, -60990.2660283281188711,
-55445.0885838485563930, -49899.9111393689939185, -44354.7336948894314439,
-38809.5562504098689693, -33264.3788059303064912, -27719.2013614507440185,
-22174.0239169711824498, -20510.4706836273200672, -18846.9174502835021912,
-17737.8819613877641022, -16628.8464724925492266, -15519.8109835994272112,
-14965.2932391551916034, -14410.7754947146766344, -13856.2577502816029460,
-13301.7400058634118150, -12747.2222614749858050, -12192.7045171460900432,
-11638.1867729362548083, -11083.6690289645407566, -10529.1512854690695820,
-9974.63354292608620089, -9420.11580228808657456, -8865.59806546008711603,
-8311.08033625221863883, -7756.56262228513473200, -7202.04493880171055809,
-6647.52731629396961299, -6093.00981577106128650, -5538.49255935177176768,
-4983.97579167624661567, -4429.46000364007375882, -3874.94618353590282056,
-3320.43633428133439223, -2765.93456971959801893, -2211.44957214006085544,
-1657.00072545683415248, -1102.63689396137728749, -548.523783020649678355,
-479.303685612597087790, -410.103507771019607286, -340.930746845646155091,
-271.797948987745926763, -202.728589967468744076, -133.775198381652975971,
-65.1041210297877634069)
stopifnot( all.equal(lp2, pbeta(x,a,b,log.=TRUE), tol=2e-16) )# pbeta() check

qp2 <- qbeta(lp2, a,b, log.p=TRUE)# 7 precision warnings in R <= 3.1.0
pq2 <- pbeta(qp2, a,b, log.p=TRUE)
stopifnot(qp2 > 0, is.finite(pq2))
## ideally   x == qbeta(pbeta(x, *), *) :
all.equal(    x,      qp2,  tol=0)#  2.075e-16  was 1.956845e-08, but .. *misleading* a bit
all.equal(log(x), log(qp2), tol=0)#  1.676e-16  was 1.0755 !!
## ideally  lp2 == pbeta(qbeta(lp2, *), *) :
all.equal(lp2, pq2, tol=0)# 1.26e-16;  was 1.07...
relE <- 1 - qp2/x
rel2 <- 1 - pq2/lp2
stopifnot(print(mean(abs(relE))) < 7e-14, # 1.53e-14   was 0.9913043 (R 3.1.0), then 0.8521738
	  print(max (abs(relE))) < 6e-13, # 1.43e-13
          print(mean(abs(rel2))) < 4e-16, # ~ 3e-17 (!); was 0.9913043 (R 3.1.0), then 0.8521738
          print(max (abs(rel2))) < 8e-16) # 2.22e-16
proc.time() - .pt; .pt <- proc.time()


### even more extreme (a,b) [still computable with Rmpfr pbetaI():]
a <- 2^12; b <- 2
x <- 2^-c(10*(100:2), 17, 2*(7:4), 7:1, .5, .25)
curve(pbeta(x,a,b, log=TRUE), n=1025, log="x", 1e-300, .1)
mtext(paste("(a=2^12, b=2) --", R.version.string))
abline(h=0, v=1, lty=3); axis(1, at=1, padj=-1, col.axis=2)

if(interactive() && require(Rmpfr)) {
    pbi <- pbetaI(x, a,b, log.p=TRUE, precBits = 2048)
    ## plus experiments, to see that 2048 bits are way enough ...
    dput(format(roundMpfr(pbi, 64))) ##
    stopifnot( all.equal(pbi, pbeta(x,a,b,log.=TRUE), tol=2e-16) )
} ## plus manual editing, removing all  ' " ' :

lp3 <- c(-2839122.53356325844061, -2810731.22504752308055, -2782339.91653178772071,
-2753948.60801605236088, -2725557.29950031700105, -2697165.99098458164121,
-2668774.68246884628115, -2640383.37395311092132, -2611992.06543737556149,
-2583600.75692164020165, -2555209.44840590484182, -2526818.13989016948199,
-2498426.83137443412193, -2470035.52285869876209, -2441644.21434296340226,
-2413252.90582722804243, -2384861.59731149268259, -2356470.28879575732276,
-2328078.98028002196270, -2299687.67176428660287, -2271296.36324855124303,
-2242905.05473281588320, -2214513.74621708052337, -2186122.43770134516330,
-2157731.12918560980347, -2129339.82066987444364, -2100948.51215413908380,
-2072557.20363840372386, -2044165.89512266836402, -2015774.58660693300419,
-1987383.27809119764424, -1958991.96957546228441, -1930600.66105972692458,
-1902209.35254399156463, -1873818.04402825620480, -1845426.73551252084496,
-1817035.42699678548502, -1788644.11848105012518, -1760252.80996531476535,
-1731861.50144957940540, -1703470.19293384404557, -1675078.88441810868562,
-1646687.57590237332579, -1618296.26738663796596, -1589904.95887090260601,
-1561513.65035516724618, -1533122.34183943188634, -1504731.03332369652639,
-1476339.72480796116656, -1447948.41629222580673, -1419557.10777649044678,
-1391165.79926075508695, -1362774.49074501972711, -1334383.18222928436717,
-1305991.87371354900733, -1277600.56519781364750, -1249209.25668207828755,
-1220817.94816634292772, -1192426.63965060756777, -1164035.33113487220794,
-1135644.02261913684811, -1107252.71410340148816, -1078861.40558766612833,
-1050470.09707193076849, -1022078.78855619540860, -993687.480040460048713,
-965296.171524724688823, -936904.863008989328989, -908513.554493253969099,
-880122.245977518609209, -851730.937461783249319, -823339.628946047889485,
-794948.320430312529595, -766557.011914577169705, -738165.703398841809872,
-709774.394883106449981, -681383.086367371090091, -652991.777851635730201,
-624600.469335900370368, -596209.160820165010477, -567817.852304429650587,
-539426.543788694290754, -511035.235272958930864, -482643.926757223570974,
-454252.618241488211112, -425861.309725752851222, -397470.001210017491360,
-369078.692694282131498, -340687.384178546771608, -312296.075662811411746,
-283904.767147076051856, -255513.458631340691994, -227122.150115605332118,
-198730.841599869972242, -170339.533084134612366, -141948.224568399252504,
-113556.916052663893531, -85165.6075369294638477, -56774.2990221466148739,
-48256.9064741001263457, -39739.5139727740774909, -34061.2524527157125043,
-28382.9914822588674710, -22704.7327152528820928, -19865.6057919927700013,
-17026.4828436463425554, -14187.3679884148968711, -11348.2699182657980446,
-8509.20804096757424162, -5670.23129358494148988, -2831.50574442529708752,
-1412.47477359632328309, -703.301613239304818981)
stopifnot( all.equal(lp3, pbeta(x,a,b,log.=TRUE), tol=2e-16) )# pbeta() check

qp3 <- qbeta(lp3, a,b, log.p=TRUE)
pq3 <- pbeta(qp3, a,b, log.p=TRUE)
stopifnot(qp3 > 0, is.finite(pq3))
## ideally   x == qbeta(pbeta(x, *), *) :
all.equal(    x,      qp3,  tol=0)# 1.599e-16
all.equal(log(x), log(qp3), tol=0)# 1.405e-16
## ideally  lp3 == pbeta(qbeta(lp3, *), *) :
all.equal(lp3, pq3, tol=0)# 1.07... then TRUE!
relE <- 1 - qp3/x
rel2 <- 1 - pq3/lp3
stopifnot(print(mean(abs(rel2))) < 3e-15,# 0  !!
	  print(mean(abs(relE))) < 8e-14,# 1.518e-14 \\ 3.584e-14 for --disable-long-double
	  print(max (abs(relE))) < 4e-13)# 5.251e-14 \\ 2.140e-13 w/o long-double
proc.time() - .pt; .pt <- proc.time()

## PR#17746 -- qbeta() not converging {from bad start}

## Componentwise aka "Vectorized" relative error
## {simplified (less robust; no arrays) from sfsmisc::relErrV()} :
relErrV <- function(target, current, eps0 = .Machine$double.xmin) {
    n <- length(target <- as.vector(target))
    ## assert( <length current> is multiple of <length target>) :
    lc <- length(current)
    if(lc %% n)
	stop("length(current) must be a multiple of length(target)")
    recycle <- (lc != n) # explicitly recycle
    R <- if(recycle)
	     target[rep(seq_len(n), length.out=lc)]
	 else
	     target
    R[] <- 0
    ## use *absolute* error when target is zero {and deal with NAs}:
    t0 <- abs(target) < eps0 & !(na.t <- is.na(target))
    R[t0] <- current[t0]
    ## absolute error also when it is infinite, as (-Inf, Inf) would give NaN:
    dInf <- is.infinite(E <- current - target)
    R[dInf] <- E[dInf]
    useRE <- !dInf & !t0 & (na.t | is.na(current) | (current != target))
    R[useRE] <- (current/target)[useRE] - 1
    R
}

qbetShRelErr <- function(p=0.001, i=0.01, from=1/4, to=4,
                   n.I = 5, n.seq = 65, # { = 1 + 2^k <==> 2^k intervals }
                   lower.tail=FALSE, xI = NULL)
{
    stopifnot(is.numeric(n.seq), n.seq >= 2,
              is.numeric(n.I),   n.I >= 2,
              is.logical(lower.tail), !is.na(lower.tail))
    if((has.I <- is.numeric(xI) && length(xI) >= 2)) {
        x <-
            if(length(xI) == 2)        seq(from=xI[1], to=xI[2], length.out = n.I)
            else if(length(xI) == 4) c(seq(from=xI[1], to=xI[2], length.out = n.I),
                                       seq(from=xI[3], to=xI[4], length.out = n.I))
            else { warning("length(xI) == ", length(xI)); x <- numeric()
                for(j in seq_len(floor(length(xI)/2)))
                    x <- c(x, seq(from=xI[2*j-1], to=xI[2*j], length.out = n.I))
            }
    } else { # does *not* have xI
        xI <- c(from, to)
        x <- seq(from=from, to=to, length.out = n.seq)
    }

    qb <- qbeta(p, shape1=i/x, shape2=(1-i)/x, lower.tail=lower.tail)
    pb <- pbeta(qb,shape1=i/x, shape2=(1-i)/x, lower.tail=lower.tail)
    relErrV(p, pb)
}

chk_relE <- function(relE, meanTol, maxTol, na.rm=FALSE) {
    stopifnot(maxTol >= 0, meanTol >= 0)
    a.relE <- abs(relE)
    mnErr <- mean(a.relE, na.rm=na.rm)
    mxErr <- max (a.relE, na.rm=na.rm)
    cat(sprintf("mean(abs(relE)) = %9.4g\n max(abs(relE)) = %9.4g\n",
                mnErr, mxErr))
    stopifnot(mnErr <= meanTol, mxErr <= maxTol)
}

chk_relE(qbetShRelErr(0.001,  i=0.001), 8e-16, 4e-15) # seen 9.22e-17, 6.66e-16
chk_relE(qbetShRelErr(0.0001, i=0.001, xI = c(1.065625, 1.285)), 8e-16, 4e-15)# 3.997e-16, 6.66e-16
## back to default p=0.001 :
chk_relE(qbetShRelErr(i=0.00101, xI = c(12.565, 97.075)),     8e-16, 1e-15) # 0 0
chk_relE(qbetShRelErr(i=0.00105, xI = c(5.539125, 31.26425)), 8e-16, 1e-15) # 0 0
chk_relE(qbetShRelErr(i=0.0011,  xI = c(3.92275, 18.65525)),  4e-16, 1e-15) # 8.88e-17  2.22e-16
chk_relE(qbetShRelErr(i=0.0012,  xI = c(2.81275, 11.119375)), 8e-16, 1e-15) # 0 0
chk_relE(qbetShRelErr(i=0.0015,  xI = c(1.907125, 5.758)),    8e-16, 1e-15) # had warnings
chk_relE(qbetShRelErr(i=0.002,   xI = c(1.508125, 3.660625)), 8e-16, 1e-15) #  "   "
chk_relE(qbetShRelErr(i=0.005,   xI = c(1.13875, 1.7575)), 8e-16, 1e-15)    #  "   "
chk_relE(qbetShRelErr(i=0.008,   xI = c(1.076875, 1.39375)), 8e-16, 1e-15)  #  "   "
chk_relE(qbetShRelErr(,          xI = c(1.05625, 1.27)), 8e-16, 1e-15)      #  "   "
chk_relE(qbetShRelErr(i=0.0113,  xI = c(1.16875, 1.21)), 8e-16, 1e-15)      #  "   "
chk_relE(qbetShRelErr(i=0.0115,  xI = c(1.18798, 1.20183)), 2e-15, 4e-15)   # 7.55e-16 1.11e-15 (had warnings)
chk_relE(qbetShRelErr(i=0.0117), 8e-14, 1e-12) # 2.12e-14 2.356e-13 not so good

## now larger p:
chk_relE(qbetShRelErr(0.002, xI = c(1.133125, 1.744375)), 8e-16, 1e-15) # had warnings
chk_relE(qbetShRelErr(0.003, xI = c(1.22689, 2.2506)), 8e-16, 1e-15)    # had warnings
chk_relE(qbetShRelErr(0.005, xI = c(1.49501, 3.62496)), 8e-16, 1e-15)   # -- warn. ; even larger jump
chk_relE(qbetShRelErr(0.008, xI = c(2.52003, 9.34491)), 8e-16, 1e-15) # had warnings
chk_relE(qbetShRelErr(0.009, xI = c(3.68804, 17.0798)), 8e-16, 1e-15) #  "   "
## "FIXME": can be smarter: when result is close to '1' have accuracy loss in that order or magnit.!
chk_relE(qbetShRelErr(0.01, from=.01, to=50), 8e-16, 1e-14) #  1.264e-16 4.885e-15 (nothing)
chk_relE(qbetShRelErr(0.01,  0.02, xI = c(1.48001, 3.58184)), 8e-16, 1e-15) # -- warn.  bump ~ [1.6, 3.6]
chk_relE(qbetShRelErr(0.015, 0.02, xI = c(2.19952, 7.50192)), 8e-16, 1e-15) # -- warn. bump ~ [2.2, 7.5]
chk_relE(qbetShRelErr(0.018, 0.02, xI = c(3.6472, 16.8828)), 8e-16, 1e-15) # -- warn.
chk_relE(qbetShRelErr(0.02, 0.03, to=7), 8e-16, 2e-15) ## 9.736e-17 6.661e-16 ; had 2 bumps [1.847, 1.982] and [2.994, 5.57]
chk_relE(qbetShRelErr(0.022, 0.03 , xI = c(2.9354, 6.94593)), 8e-16, 1e-15) # had warnings
chk_relE(qbetShRelErr(0.022, 0.035, xI = c(1.88914, 1.95886,  3.59804, 4.9232)), 8e-16, 1e-15) # -- 2 bumps !
chk_relE(qbetShRelErr(0.022, 0.035, xI = c(1.85814, 1.96273,  3.59029, 4.94258)), 8e-16, 1e-15)# - 2 bumps !

chk_relE(qbetShRelErr(0.025, 0.035, xI = c(3.46928, 6.47119)), 8e-16, 1e-15)
chk_relE(qbetShRelErr(0.975, 0.035, lower.tail=TRUE, xI = c(3.47291, 6.47444)), 8e-16, 1e-15)
chk_relE(qbetShRelErr(0.97 , 0.035, lower.tail=TRUE, xI = c(3.28853, 12.2711)), 8e-16, 1e-15)
chk_relE(qbetShRelErr(0.969, 0.035, lower.tail=TRUE, xI = c(3.33278, 14.8597)), 8e-16, 1e-15)
chk_relE(qbetShRelErr(0.967, 0.035, lower.tail=TRUE, xI = c(4.84642, 26.162)), 8e-16, 1e-15)
chk_relE(qbetShRelErr(0.966, 0.035, lower.tail=TRUE, xI = c(6.99119, 44.4524)), 8e-16, 1e-15)  # had warnings
chk_relE(qbetShRelErr(0.965, 0.035, lower.tail=TRUE), 8e-16, 1e-15)# 0 0  {much changed picture ...}
pp. <- c(.965, .966)
stopifnot(all.equal(tol = 1e-15, pp.,
                    pbeta(print(qbeta(pp., .0035, .097)),
                          .0035, .097)))

pbeta(1e-323,  1/200, 1/100) # 0.01617775 >> 0.01
## really smallest non zero (with subnormals!): 2^-(1022+52) == 2^-1074:
pbeta(2^-1074, 1/200, 1/100) # 0.01612178 >> 0.01

qbeta(.80, 1/100, 1/200)# gives 1 without a warning -- which *is* good:
(qb.2 <- qbeta(.20, 1/200, 1/100)) # 2.613271e-105
(pqb.2 <- pbeta(qb.2, 1/200, 1/100))# 0.2 -- very good:
0.2 - pqb.2 # -2.77..e-17
stopifnot(all.equal(0.2, pqb.2, tol = 1e-15))

## completely different picture: smaller values; increasing -- max (~ 2.4) -- decreasing (????)
chk_relE(qbetShRelErr(0.96 , 0.035, to= 15, lower.tail=TRUE),  8e-16, 1e-15)# completely different (mostly decreasing, no bump)
chk_relE(qbetShRelErr(0.04 , 0.035, to= 15, lower.tail=FALSE), 8e-16, 1e-15)#  (ditto)
chk_relE(qbetShRelErr(0.95 , 0.035, to= 15, lower.tail=TRUE),  8e-16, 1e-15)#  (ditto)
chk_relE(qbetShRelErr(0.022, 0.04, to=20), 1e-13, 1e-12) # 2.484e-14 2.323e-13 ("close to 1"-FIXME above)
chk_relE(qbetShRelErr(0.04, 0.06, to=20, n.seq=1+256), 5e-15, 4e-14)# 1.02e-15  1.044e-14 ("close to 1"-FIXME above)
chk_relE(qbetShRelErr(0.04, 0.08, to=40, n.seq=1+256), 1e-6 , 5e-5 )# 2.673e-07 1.065e-05 ("close to 1"-FIXME above)
chk_relE(qbetShRelErr(0.05, 0.07, from=.1, to=70, n.seq=1+256), 9e-9, 2e-7)# 1.509e-09 4.389e-08 ( "   "   " )

## Now, the "necessarily hard" cases {reason: "correct underflow "}:
options(warn = 1)# warnings allowed, happen immediately

qbeta(.99, 1/100, 1/200)# *does* warn and gives 1 (but should *NOT* use 575 Newton steps!)
##                                                  =============== FIXME !!!!!!!!!!!!!!
## *and* should not warn, the warning would apply to the *other* tail only !
qbeta(.01, 1/200, 1/100)# 4.283133e-301 {and *does* warn; ok} *and* uses (practically almost) the same 575 N steps
##--------- "zoom in": the last one uses 997 Newton steps (FIXME!)
pX <- .98 + c(1, 3, 6:8)*1e-4
(qbX <- qbeta(pX, 1/100, 1/200))
stopifnot(qbX == 1) # correctly
## however, here we *could* get accuracy, here -- by "swap_tail", only those >= 0.9807 "fail":
signif(qbX <- qbeta(pX, 1/200, 1/100, lower.tail=FALSE), 5)
## 9.5896e-306 1.2718e-306 5.9092e-308 1.0386e-299 9.7579e-300
## "swap tail": 1-.9807
qbeta(.0193, 1/200, 1/100) #  1.038564e-299 + warning .. not accurate

## PR#18302  (about qf(),  really about qbeta())  ====================
options(warn=2) # no warnings
qq <- qf(-37.4, df1 = 227473.5, df2 = 2.066453, log.p = TRUE)
stopifnot(all.equal(0.027519098277, qq, tol=2e-11))
x <- lseq(1e-300, 1, 1000) # 1e-300  2e-300 .... 0.25.. 0.50.. 1.0
q2L <- qf(log(x), df1 = 23e4, df2 = 2, log.p=TRUE)
stopifnot(all.equal(log(x), pf(q2L, df1=23e4, df2=2, log.p=TRUE)))
xN <-  -300+ (-27:7)/2
qb. <- qbeta(xN,  1, 115000, lower.tail=FALSE, log.p=TRUE)
pqb <- pbeta(qb., 1, 115000, lower.tail=FALSE, log.p=TRUE)
stopifnot(all.equal(xN, pqb, tol=1e-14))
          all.equal(xN, pqb, tol=0) # ... 1.86e-16
x <- seq(-700, 0, by=1/2); x <- x[x < 0] # x == 0 <==> qf = +Inf
qfx <- qf(x, df1 = 23e4, df2 = 2, log.p=TRUE) # gave 71 warnings
stopifnot(0 < qfx, qfx < 2) # and even
stopifnot(all.equal(x, pf(qfx, df1 = 23e4, df2 = 2, log.p=TRUE)))
          all.equal(x, pf(qfx, df1 = 23e4, df2 = 2, log.p=TRUE), tol=0) # 5.6e-15
## log.p=FALSE [default] cases that failed (or gave warnings)
ps <- lseq(1e-300, 0.1, 1001)
qf.  <- qf(ps , df1 = 227473.5, df2 = 2.06)
pqpf <- pf(qf., df1 = 227473.5, df2 = 2.06)
          all.equal(ps, pqpf, tol = 0) # rel.diff. 7.41309e-16
stopifnot(all.equal(ps, pqpf, tol = 8e-15))
qps <- qbeta(ps,  1.03, 115000, lower.tail = FALSE)# works (35 u-Newton steps)
pqp <- pbeta(qps, 1.03, 115000, lower.tail = FALSE)
          all.equal(ps, pqp, tol = 0) # rel.diff. 1.150378e-15
stopifnot(all.equal(ps, pqp, tol = 1e-14))
## NB: there are *still* gaps for other df-pairs -- but *only* from pbeta() bpser underflow problems there


### pbeta()  warnings  /// close to underflow situation ----

options(warn=1) # immediate warnings

## b = 1 ==> pbeta(x,a,1)  =  x^a  (mathematically, not quite numerically)

x <- 1e-311*2^(-2:5)

a <- 9.9999e-16
##==> all work via  apser():
all.equal(x^a, pbeta(x, a, 1), tol=0)               # 1.11e-16 -- perfect
all.equal(a*log(x), pbeta(x, a, 1, log=TRUE), tol=0)# 3.5753e-13 -- less perfect

## only very slightly larger a:
a <- 1e-15
all.equal(x^a, p <- pbeta(x, a, 1), tol=0)# bgrat() underflow warnings # 7.12208e-13
## numbers are very close to 1 ==> not such a problem
cbind(x, "x^a" = x^a, pbeta = p, relE = p/(x^a) - 1,
      "1-x^a (expm1)" = -expm1(a*log(x)), "1-pb" = 1-p,
      ## interestingly, even this does *not* improve the situation:
      "pb_upp" = pbeta(x, a, 1, lower.tail=FALSE))

all.equal(a*log(x), pL <- pbeta(x, a, 1, log=TRUE), tol=0)#
## 0.853 ... catastrophic! -- it's off for x <= 8e-311 :
cbind(x, "a*log" = a*log(x), pbetaL = pL, relE = pL/(a*log(x)) - 1)


## pbeta(*, log.p=TRUE)  now underflows to -Inf too often
##                       If it does it *should* give a warning, at least!
try.pb <- function(x, a,b, log.p=TRUE)
    tryCatch(pbeta(x, a,b, log.p=log.p), error=identity, warning=identity)
check.pb <- function(pb, true)
    stopifnot((inherits(pb, "warning") && grepl("\\bInf\\b", pb$message)) ||
              isTRUE(all.equal(print(pb), true, tol = 2e-7))) # << print(.) : see value

## True values via  require(Rmpfr); asNumeric(pbetaI(326/512, 1900, 38, log=TRUE))
##
## Those with*out* a '#' mark all did  *not* underflow in R 2.9.1, nor R 2.10.1,
## but did give NaN in 2.11.x (x >= 0)  and -Inf later === *regression* _FIXME_
## i.e., the fix for PR#14230 pbeta(x, 3, 2200, lower.tail=FALSE, log.p=TRUE),
## svn diff -c51327 (2010-03-19) was *not* helpful in these cases
##
check.pb(try.pb(437/512, 4711, 19), true = -664.8560)# did work in R <= 2.10.1 (see above)
check.pb(try.pb(442/512, 4998, 19), true = -653.6326)
check.pb(try.pb(430/512, 4208, 20), true = -649.9831)
check.pb(try.pb(428/512, 4348, 20), true = -693.6123)
check.pb(try.pb(429/512, 4348, 20), true = -683.6925)
check.pb(try.pb(421/512, 4012, 21), true = -695.9839)
check.pb(try.pb(422/512, 4012, 21), true = -686.6862)
check.pb(try.pb(423/512, 4012, 21), true = -677.4135)
check.pb(try.pb(441/512, 4969, 20), true = -656.8775)
check.pb(try.pb(442/512, 4969, 20), true = -645.8918)
check.pb(try.pb(443/512, 4969, 20), true = -634.9354)

check.pb(try.pb(407/512, 3455, 22), true = -700.4242)
check.pb(try.pb(435/512, 4996, 23), true = -716.9553)
check.pb(try.pb(397/512, 3000, 24), true = -664.8547)
check.pb(try.pb(397/512, 3070, 24), true = -682.1341)
check.pb(try.pb(393/512, 3070, 24), true = -712.4377)
check.pb(try.pb(412/512, 3530, 24), true = -668.2493)

check.pb(try.pb(400/512, 3085, 25), true = -659.8754)
check.pb(try.pb(409/512, 3352, 25), true = -651.2284)
check.pb(try.pb(400/512, 3352, 25), true = -723.8049)
check.pb(try.pb(415/512, 3541, 25), true = -642.2389)
check.pb(try.pb(430/512, 4291, 25), true = -646.8498)

check.pb(try.pb(377/512, 2551, 26), true = -675.8778)
check.pb(try.pb(370/512, 2551, 26), true = -722.4272)
check.pb(try.pb(412/512, 3505, 26), true = -656.3025)

check.pb(try.pb(370/512, 2499, 27), true = -702.7537)
check.pb(try.pb(367/512, 2499, 27), true = -722.5556)

check.pb(try.pb(363/512, 2318, 28), true = -685.6969)
check.pb(try.pb(360/512, 2399, 28), true = -732.005)

check.pb(try.pb(348/512, 2158, 29), true = -717.8487)
check.pb(try.pb(367/512, 2397, 29), true = -683.2321)
check.pb(try.pb(380/512, 2661, 29), true = -678.227)

check.pb(try.pb(362/512, 2292, 30), true = -676.8534)
check.pb(try.pb(369/512, 2495, 30), true = -698.3849)

check.pb(try.pb(326/512, 1900, 38), true = -714.7700)
## all those check.pb() above *did* work in R <= 2.10.1 ----

## all those below have always underflowed (or worse) -- now give *warning* at least:
check.pb(try.pb(412/512, 4996, 23), true = -982.6083)#
check.pb(try.pb(400/512, 4291, 25), true = -949.7046)#

check.pb(try.pb(370/512, 3700, 28), true = -1079.069)#
check.pb(try.pb(401/512, 3700, 28), true = -788.0158)#
check.pb(try.pb(351/512, 4777, 28), true = -1670.472)#

check.pb(try.pb(365/512, 3699, 29), true = -1124.502)#
check.pb(try.pb(341/512, 2146, 30), true = -752.5865)#

check.pb(try.pb(289/512, 1900, 38), true = -936.9607)#
check.pb(try.pb(290/512, 1900, 38), true = -930.5637)#
check.pb(try.pb(293/512, 1900, 38), true = -911.5123)#
check.pb(try.pb(295/512, 1900, 38), true = -898.9261)#
check.pb(try.pb(296/512, 1900, 38), true = -892.6670)#
check.pb(try.pb(302/512, 1900, 38), true = -855.5796)#
check.pb(try.pb(305/512, 1900, 38), true = -837.3302)#
check.pb(try.pb(308/512, 1900, 38), true = -819.2725)#



## keep at end
rbind(last =  proc.time() - .pt,
      total = proc.time())

