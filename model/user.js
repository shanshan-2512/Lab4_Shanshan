const dbConnPool = require("./db");
const sha256 = require("crypto-js/sha256"); //usage： hash = sha256('Message‘)
const async = require("hbs/lib/async");


let Users = {};

Users.addUser = async function (userData) {

  const result = {
    status: false,
    user: null,
    message: "unable to create account"
  }


  if (userData !== undefined && userData.username !== undefined && userData.username.length > 0 && userData.password !== undefined && userData.first !== undefined && userData.email !== undefined) {

    let userResult = await this.getUserForUsername(userData.username);

    if (userResult.status) {
      result.message = `user ${userData.username} already exists`;
    } else {
      userData.passHash = sha256(userData.password).toString();
      userData.username = userData.username.toLowerCase();
      let dbConn = await dbConnPool.getConnection();
      const queryResult = await dbConn.query("INSERT INTO `restaurant`.`user` (`username`, `first`, `passHash`, `email`) VALUES (?,?,?,?);",
        [userData.username, userData.first, userData.passHash, userData.email]);
      dbConn.end();

      if (queryResult.affectedRows == 1) {
        result.status = true;
        result.user = userData;
        result.message = `user ${queryResult.insertId}:${userData.username} added.`
        result.user.userId = queryResult.insertId;
      }
    }
  }

  return result;
}


Users.authWithCookies = async function (username, hash) {
  let dbConn = await dbConnPool.getConnection();
  const rows = await dbConn.query(
    "SELECT  `userId`,  `username`,  `first`,  `cookieHash`, `email` FROM `restaurant`.`user` WHERE `username`=?",
    [username]
  );
  dbConn.end();
  const result = {
    status: false,
    user: null,
    message: "unable to login"
  }

  if (rows[0] === undefined) {
    result.message = 'invalid user';
    return result;
  }

  const userInfo = rows[0];
  if (userInfo.cookieHash === hash) {
    result.status = true;
    result.user = userInfo;
    result.message = "logged in"
    return result;
  }

  result.message = 'invalid cookies';
  return result;


}


Users.authWithPassword = async function (username, password) {
  let dbConn = await dbConnPool.getConnection();
  const rows = await dbConn.query(
    "SELECT  `userId`,  `username`,  `first`,  `passHash`, `email` FROM `restaurant`.`user` WHERE `username`=?",
    [username]
  );
  dbConn.end();
  const result = {
    status: false,
    user: null,
    message: "unable to login"
  }

  if (rows[0] === undefined) {
    result.message = 'invalid user';

    return result;
  }

  let userInfo = rows[0];
  let passHash = sha256(password).toString();


  if (userInfo.passHash === passHash) {
    //password match, username exists
    userInfo.cookieHash = sha256(new Date().getTime + "" + userInfo.userId).toString();
    this.setCookieHash(userInfo.username, userInfo.cookieHash);

    result.status = true;
    result.user = userInfo;
    result.message = "logged in"

    return result;
  }

  result.message = 'invalid password';
  return result;
  // SELECT  `userId`,  `username`,  `first`,  `passHash`,  `cookieHash`, `email` FROM `restaurant`.`user` WHERE `username`='ethan'


}

Users.setCookieHash = async (username, hash) => {
  let dbConn = await dbConnPool.getConnection();
  const rows = await dbConn.query("UPDATE `restaurant`.`user` SET `cookieHash`=? WHERE `username`=?;", [hash, username]);
  // UPDATE `restaurant`.`user` SET `cookieHash`='03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4' WHERE `username`='ethan';
  dbConn.end();
}


Users.getUser = async (userId) => {
  let result = {};
  if (isNaN(userId)) {
    result.status = false;
  } else {
    let dbConn = await dbConnPool.getConnection();
    const rows = await dbConn.query(
      "SELECT userId, username, `first` FROM `user` WHERE userId = ?",
      [userId]
    );

    dbConn.end();
    //console.log(rows);
    if (rows.length > 0) {
      result.status = true;
      result.rows = rows[0];
      //console.log(rows[0]);
    } else {
      result.status = false;
    }
  }

  return result;
};

Users.getUsers = async () => {
  let result = {};
  let dbConn = await dbConnPool.getConnection();
  const rows = await dbConn.query(
    "SELECT userId, username, `first` FROM `user`"
  );
  dbConn.end();
  //console.log(rows);
  result.data = rows;
  return result;
};


Users.getUserForUsername = async (username) => {
  let result = {};
  if (username === undefined) {
    result.status = false;
  } else {
    username = username.toLowerCase();
    let dbConn = await dbConnPool.getConnection();
    const rows = await dbConn.query(
      "SELECT userId, username, `first` FROM `user` WHERE username = ?",
      [username]
    );

    dbConn.end();
    //console.log(rows);
    if (rows.length > 0) {
      result.status = true;
      result.rows = rows[0];
      //console.log(rows[0]);
    } else {
      result.status = false;
    }
  }

  return result;
};

module.exports = Users;
