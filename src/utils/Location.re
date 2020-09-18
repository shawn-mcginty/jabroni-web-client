[@bs.val] external window: 'a = "window";

let host = (): string => {
	window##location##host;
};

let protocol = (): string => {
	window##location##protocol;
};