const jwt = require("jsonwebtoken");
require("dotenv").config();

const GenerateToken = (id) => {
  return jwt.sign({ id }, process.env.SECRECT_KEY, {
    expiresIn: "24h",
  });
};

module.exports = GenerateToken;
