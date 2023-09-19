const {readFileSync, writeFileSync, mkdirSync} = require("fs");
const {resolve} = require("path");

const cwd = process.cwd();

mkdirSync(resolve(cwd, "./rider_only"), {recursive: true})
mkdirSync(resolve(cwd, "./vehicle_only"), {recursive: true})


const source = readFileSync(resolve(cwd, "./both/GSCarrier.lua")).toString("utf8")

const rider_source = source.replace(
  /[ \t]*--!! VEHICLE_ONLY\r?\n.*?[ \t]*--!! END(?:\r?\n?){1,2}/gs, ""
)
const vehicle_source = source.replace(
  /[ \t]*--!! RIDER_ONLY\r?\n.*?[ \t]*--!! END(?:\r?\n?){1,2}/gs, ""
)

writeFileSync(resolve(cwd, "./rider_only/GSCarrier.lua"), rider_source)
writeFileSync(resolve(cwd, "./vehicle_only/GSCarrier.lua"), vehicle_source)
