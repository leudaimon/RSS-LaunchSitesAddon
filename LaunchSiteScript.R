data <- read.csv("Launch_Sites.csv")
data.include <- data[data$Include == 1,]
Sites <- vector(mode = "list")
SitesHead <- c("@KSCSWITCHER:AFTER[RealSolarSystem]",
               "{",
               "  @LaunchSites",
               "  {")
for (i in 1:nrow(data.include)) {
    Sites[[i]] <- c(
    "    Site",
    "    {",
    iconv(tolower(paste("      name = ", data.include$Code[i], "_", 
                  strsplit(as.character(data.include$Location[i]), split = " ", fixed = T)[[1]][1], 
                  sep = "")), from = 'UTF-8', to = 'ASCII//TRANSLIT'),
    paste("      displayName = ", toupper(data.include$Code)[i], " - ", data.include$Location[i], sep = ""),
    "      description =",
		"      PQSCity",
		"      {",
	  "        KEYname = KSC",
		paste("        latitude = ", data.include$Lat[i], sep = ""),
		paste("        longitude = ", data.include$Long[i], sep = ""),
		paste("        repositionRadiusOffset = ", data.include$altitude[i]+50, sep = ""),
		"        repositionToSphereSurface = false",
		"        lodvisibleRangeMult = 6",
		paste("        reorientFinalAngle = ", -90-data.include$Long[i], sep = ""),
		"      }",
		"      PQSMod_MapDecalTangent",
		"      {",
		"        radius = 20000",
		"        heightMapDeformity = 80",
		paste("        absoluteOffset = ", data.include$altitude[i], sep = ""),
		"        absolute = true",
		paste("        latitude = ", data.include$Lat[i], sep = ""),
		paste("        longitude = ", data.include$Long[i], sep = ""),
		"      }",
		"    }")
}

writeLines(c(SitesHead,unlist(Sites), "  }","}"), con = "GameData/RSS-Sites/Sites.cfg")


Comm <- vector(mode = "list")
CommHead<-c("@Kopernicus:BEFORE[RealSolarSystem_Late]", 
            "{",
            "  @Body[Kerbin]",
            "  {",
            "    @PQS",
            "    {",
            "      @Mods",
            "      {")
for (i in 1:nrow(data.include)) {
  Comm[[i]] <- c(
    "        City2",
    "        {",
    "          name = LaunchSiteTrackingStation",
    paste("          objectName = ", toupper(data.include$Code)[i], " - ", data.include$Location[i], sep = ""),
    "          isKSC = True",
    "          commnetStation = True",
    "          snapToSurface = True",
    paste("          lat = ", data.include$Lat[i], sep = ""),
    paste("          lon = ", data.include$Long[i], sep = ""),
    paste("          alt = ", round(data.include$altitude[i],digits = 0) + 150, sep = ""),
    "          snapHeightOffset = 0",
    "          up = 0.0, 1.0, 0.0",
    "          rotation = 0",
    "          order = 100",
    "          enabled = True",
    "          LOD",
    "          {",
    "            Value",
    "            {",
    "              visibleRange = 30000",
    "              keepActive = False",
    "              model = BUILTIN/Dish",
    "              scale = 0.1, 0.1, 0.1",
    "              delete = False",
    "            }",
    "          }",
    "        }"
    )
}

writeLines(c(CommHead,unlist(Comm), "      }", "    }", "  }", "}"), con = "GameData/RSS-Sites/CommNet_Sites.cfg")

