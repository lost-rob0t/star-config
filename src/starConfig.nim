import std/[os, parsecfg, strutils]
const
  CONFIG_DIR = getConfigDir()
  CONFIG_PATH = CONFIG_DIR / "star.ini"
type
  StarConfig* = object
    ## Configuration for Starintel projects to use
    database*: string
    targetdb*: string
    dbUser*: string
    dbPass*: string
    dbHost*: string
    dbPort*: int
    redisHost*: string
    redisPort*: int
    redisPass*: string
    defaultDataset*: string



proc loadConfigFile*(path: string = CONFIG_PATH): StarConfig =

  let c = loadConfig(path)
  let database = c.getSectionValue("DB", "database")
  let targetdb = c.getSectionValue("DB", "targetdb")
  let dbUser = c.getSectionValue("DB", "user")
  let dbPass = c.getSectionValue("DB", "password")
  let dbHost = c.getSectionValue("DB", "host")
  let dbPort = c.getSectionValue("DB", "port").parseInt
  let redisHost = c.getSectionValue("REDIS", "host")
  let redisPort = c.getSectionValue("REDIS", "port").parseInt
  let redisPassword = c.getSectionValue("REDIS", "password")
  let verbose = c.getSectionValue("MAIN", "verbose").parseBool
  let defaultDataset = c.getSectionValue("MAIN", "default-dataset")
  result = StarConfig(database: database,
                  targetdb: targetdb,
                  dbUser: dbUser,
                  dbPass: dbPass,
                  dbHost: dbHost,
                  dbPort: dbPort,
                  redisHost: redisHost,
                  redisPort: redisPort,
                  redisPass: redisPassword,
                  defaultDataset: defaultDataset)


func newStarConfig*(): StarConfig =
  ## Return a default config
  result = StarConfig(database: "star-intel",
                  targetdb: "targets",
                  dbUser: "admin",
                  dbPass: "password",
                  dbHost: "127.0.0.1",
                  dbPort: 5984,
                  redisHost: "127.0.0.1",
                  redisPort: 6379,
                  redisPass: "",
                  defaultDataset: "star-intel")


proc writeConfig*(config: StarConfig = newStarConfig(), path: string) =
  var d = newConfig()
  d.setSectionKey("DB", "database", config.database)
  d.setSectionKey("DB", "targetdb", config.targetdb)
  d.setSectionKey("DB", "user", config.user)
  d.setSectionKey("DB", "password", config.password)
  d.setSectionKey("DB", "host", config.host)
  d.setSectionKey("DB", "port", config.port)
  d.setSectionKey("REDIS", "host", config.redisHost)
  d.setSectionKey("REDIS", "port", config.redisPort)
  d.setSectionKey("REDIS", "password", config.redisPass)
  d.setSectionKey("VERBOSE", "MAIN", config.verbose)
  d.setSectionKey("default-dataset", "MAIN", config.defaultDataset)
  d.writeConfig(path)
