const path = require('path');
const express = require('express');
const app = express();
const port = 8080;

const index = `<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>ReasonReact Examples</title>
	</head>
	<body>
		<section id="app"></section>
		<script src="/static/index.js"></script>
	</body>
</html>
`;

app.use('/static', express.static(path.join(__dirname, 'dist')));

app.get('/', (req, res) => {
	res.set('Content-Type', 'text/html');
	res.send(index);
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})