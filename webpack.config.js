const path = require('path');

module.exports = [{
  entry: './src/Index.bs.js',
  // If you ever want to use webpack during development, change 'production'
  // to 'development' as per webpack documentation. Again, you don't have to
  // use webpack or any other bundler during development! Recheck README if
  // you didn't know this
  mode: 'development',
  output: {
    path: path.join(__dirname, 'apps/jabroni_web_client/priv/public/js'),
    filename: 'index.js',
  },
  module: {
    rules: [{
      test: /\.css$/,
      use: ['style-loader', 'css-loader', 'postcss-loader'],
    }],
  },
}, {
  entry: './src/Login.bs.js',
  // If you ever want to use webpack during development, change 'production'
  // to 'development' as per webpack documentation. Again, you don't have to
  // use webpack or any other bundler during development! Recheck README if
  // you didn't know this
  mode: 'development',
  output: {
    path: path.join(__dirname, 'apps/jabroni_web_client/priv/public/js'),
    filename: 'login.js',
  },
  module: {
    rules: [{
      test: /\.css$/,
      use: ['style-loader', 'css-loader', 'postcss-loader'],
    }],
  },
}];