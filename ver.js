const { writeFileSync } = require("fs");

const date = new Date();
const version =
  process.env.VERSION ||
  `${date.getFullYear()}.${date.getMonth() == 0 ? date.getMonth() + 1 : 0}.${
    date.getDate() == 1 ? 0 : date.getDate()
  }` +
    (process.env.NIGHTLY == "true" ? `-nightly.${Date.now()}` : "") +
    suffix;

console.log(process.env.VERSION || `Created version ${version}`);

writeFileSync("./.version", version);
