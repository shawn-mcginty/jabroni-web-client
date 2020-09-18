type dangerousHtml = {.
	__html: string,
};

[@react.component]
let make = (~author: PublicUser.t, ~body, ~ts) => {
	let canvasRef = React.useRef(Js.Nullable.null);
	React.useEffect1(() => {
		let _ = AvatarGenerator.getSvg(PublicUser.display(author), canvasRef.current);
		None;
	}, [|author|]);

	<div className="w-full flex py-4">
		<div className="bg-transparent" style={ReactDOMStyle.make(~height="56px", ~width="56px", ())}>
			<canvas ref={ReactDOM.Ref.domRef(canvasRef)} className="sprite" height="16" width="16"></canvas>
		</div>
		<div className="flex flex-col flex-grow pl-2">
			<div className="w-full pb-2">
				<span title={"@" ++ PublicUser.handle(author)}><strong>{React.string(PublicUser.display(author))}</strong></span>
				<span className="text-gray-700 text-sm pl-2">{React.string(ts)}</span>
			</div>
			<div className="w-full">
				{React.string(body)}
			</div>
		</div>
	</div>
};