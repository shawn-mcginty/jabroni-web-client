'use strict';


var getSvg = (function getSvg(id, c) {
		let seed = 0;

		for (let sdIdx = 0; sdIdx < id.length; sdIdx++) {
			seed = seed + sdIdx + id.charCodeAt(sdIdx);
		}

		//let x = new C2S(16, 16);
		let x = c.getContext('2d');
		x.lineWidth = 2;
		let i = 1;
		let s, j, pass, X, Y;

		const R = () => (Math.sin(++s + i*i) + 1)*1e9 % 256 | 0;
		for (pass = 4; pass--;) {
			for (s = seed, j = R()/5 + 50|0; j--;) {
				X = j&7;
				Y = j>>3;
				if(R() < 19) {
					x.fillStyle = `rgb(${R()}, ${R()}, ${R()})`;
				} else if (R() ** 2 / 2e3 > X * X + (Y - 5) ** 2) {
					x[pass&2 ? 'strokeRect' : 'fillRect'](
						7 + i % 1 * 1 - pass % 2 * 2 * X + X,
						2 + (i >> 5) * 1 + Y,
						1,
						1);
				}
			}
		}
	});

exports.getSvg = getSvg;
/* No side effect */
