[@react.component]
let make = (~setShowRegisterForm, ~loginMessage) => {
	let url = ReasonReactRouter.useUrl();
	let loginFailureEl = switch (url.search) {
		| "failed=true" => <p className="text-red-800 text-center my-5">{React.string("Log in failed! Please try again.")}</p>
		| _ => <p></p>
	};
	<div className="px-10 py-5">
		<p className="text-lg my-5 text-center">
			<span>{React.string("Log in to ")}</span>
			<strong className="text-pink-700">{React.string("Jabroni")}</strong>
		</p>
		{
			switch (loginMessage) {
				| Some(msg) => <p className="text-center text-pink-700 my-5"><strong>{React.string(msg)}</strong></p>
				| None => <p></p>
			}
		}
		{ loginFailureEl }
		<form method="POST">
			<div className="my-4">
				<label htmlFor="email" className="font-bold">{React.string("Email")}</label>
				<input name="email" className="bg-white focus:outline-none border border-gray-400 rounded-lg py-2 px-4 block w-full appearance-none leading-normal focus:border-gray-600" type_="text" placeholder="smarty@coolplace.com" />
			</div>
			<div className="my-4">
				<label htmlFor="pdub" className="font-bold">{React.string("Password")}</label>
				<input name="pdub" className="bg-white focus:outline-none border border-gray-400 rounded-lg py-2 px-4 block w-full appearance-none leading-normal focus:border-gray-600" type_="password" placeholder="***********" />
			</div>
			<div className="flex">
				<div className="w-1/2">
					<Button color=Button.Branding label="Log in" onClick={_ => ()} type_="submit" />
				</div>
				<div className="w-1/2 text-right">
					<Button color=Button.Gray label="Register" onClick={e => {
						ReactEvent.Mouse.preventDefault(e);
						setShowRegisterForm(_ => true);
					}} />
				</div>
			</div>
		</form>
	</div>
};
