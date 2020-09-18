type buttonColor = | Branding | Gray;

[@react.component]
let make = (~label, ~color, ~onClick, ~type_="button") => {
	let buttonColor = switch (color) {
		| Branding => "pink"
		| Gray => "gray"
	};

	let className = Printf.sprintf("bg-transparent hover:bg-%s-500 text-%s-700 font-semibold hover:text-white py-2 px-4 border border-%s-500 hover:border-%s-700 rounded",
		buttonColor,
		buttonColor,
		buttonColor,
		buttonColor);
	<button className=className onClick=onClick type_=type_>
		{React.string(label)}
	</button>
}