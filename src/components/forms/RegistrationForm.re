let fieldHasErrors = (field, errors) => switch (errors) {
	| None => false
	| Some((badFields, _)) =>
		switch (List.find_opt((f) => f == field, badFields)) {
			| None => false
			| Some(_) => true
		}
};

[@react.component]
let make = (~setShowRegisterForm, ~setLoginMessage) => {
	let (email, setEmail) = React.useState(() => "");
	let (pdub, setPdub) = React.useState(() => "");
	let (pdub2, setPdub2) = React.useState(() => "");
	let (handle, setHandle) = React.useState(() => "");
	let (display, setDisplay) = React.useState(() => "");
	let (errors, setErrors) = React.useState(() => None);
	let errorClassName = "bg-white focus:outline-none border border-red-400 rounded-lg py-2 px-4 block w-full appearance-none leading-normal focus:border-red-600";
	let clsasName = "bg-white focus:outline-none border border-gray-400 rounded-lg py-2 px-4 block w-full appearance-none leading-normal focus:border-gray-600";

	let pdubHasErrors = fieldHasErrors("pdub", errors);
	let pdub2HasErrors = fieldHasErrors("pdub2", errors);
	let emailHasErrors = fieldHasErrors("email", errors);
	let displayHasErrors = fieldHasErrors("display", errors);
	let handleHasErrors = fieldHasErrors("handle", errors);

	let errorMsgComp = switch (errors) {
		| Some((_, message)) => <p className="text-red-800 text-center">{React.string(message)}</p>
		| _ => <p></p>
	};

	<div className="px-10 py-5">
		<p className="text-lg my-5 text-center">
			<span>{React.string("Register for ")}</span>
			<strong className="text-pink-700">{React.string("Jabroni")}</strong>
		</p>
		<p className="text-justify">
			<span>{React.string("Registration is permitted by ")}</span>
			<strong>{React.string("invitaton only")}</strong>
			<span>{React.string(". If you haven't recieved an invitation ask a friend with ")}</span>
			<span className="font-mono text-red-800 bg-gray-200">{React.string("invitation privileges")}</span>
			<span>{React.string(".")}</span>
		</p>
		{ errorMsgComp }
		<form>
			<div className="my-4">
				<label htmlFor="email" className="font-bold">{React.string("Email")}</label>
				<input
					name="email"
					className={emailHasErrors ? errorClassName : clsasName}
					type_="text"
					placeholder="smarty@coolplace.com"
					onChange={(e) => {
						let target = ReactEvent.Form.currentTarget(e);
						let newEmail = target##value;
						setEmail(_ => newEmail);
					}}
				/>
				<p className="text-sm">{React.string("This is how you will log in.")}</p>
			</div>
			<div className="my-4">
				<label htmlFor="pdub" className="font-bold">{React.string("Password")}</label>
				<input
					name="pdub"
					className={pdubHasErrors ? errorClassName : clsasName}
					type_="password"
					placeholder="***********"
					onChange={(e) => {
						let target = ReactEvent.Form.currentTarget(e);
						let newPdub = target##value;
						setPdub(_ => newPdub);
					}}
				/>
			</div>
			<div className="my-4">
				<label htmlFor="pdub2" className="font-bold">{React.string("Repeat Password")}</label>
				<input
					name="pdub2"
					className={pdub2HasErrors ? errorClassName : clsasName}
					type_="password"
					placeholder="***********"
					onChange={(e) => {
						let target = ReactEvent.Form.currentTarget(e);
						let newPdub2 = target##value;
						setPdub2(_ => newPdub2);
					}}
				/>
			</div>
			<div className="my-4">
				<label htmlFor="handle" className="font-bold">{React.string("Handle")}</label>
				<div className="inline-flex w-full">
					<input name="ignore" disabled=true className="bg-transparent focus:outline-none border-none py-2 pl-4 pr-1 block w-10 font-bold appearance-none leading-normal focus:border-none text-right text-gray-600" value="@"/>
					<input
						name="handle"
						className={handleHasErrors ? errorClassName : clsasName}
						type_="text"
						placeholder="coolio"
						onChange={(e) => {
							let target = ReactEvent.Form.currentTarget(e);
							let newHandle = target##value;
							setHandle(_ => newHandle);
						}}
					/>
				</div>
				<p className="text-sm">{React.string("This is how users will mention you.")}</p>
			</div>
			<div className="my-4">
				<label htmlFor="display" className="font-bold">{React.string("Display Name")}</label>
				<input
					name="display"
					className={displayHasErrors ? errorClassName : clsasName}
					type_="text"
					placeholder="J. Doe"
					onChange={(e) => {
						let target = ReactEvent.Form.currentTarget(e);
						let newDisplay = target##value;
						setDisplay(_ => newDisplay);
					}}
				/>
				<p className="text-sm">{React.string("This is what users will see when you're chatting.")}</p>
			</div>
			<div className="flex">
				<div className="w-1/2">
					<Button color=Button.Branding label="Register" onClick={e => {
						ReactEvent.Mouse.preventDefault(e);
						let _ = RegistrationService.registerUser(email, pdub, pdub2, display, handle)
							|> Js.Promise.then_((result: Belt.Result.t(unit, RegistrationService.registrationError)) => {
								switch (result) {
									| Ok(_) =>
										setErrors(_ => None);
										setLoginMessage(_ => Some("You can log in now."));
										setShowRegisterForm(_ => false);
										Js.Promise.resolve();
									| Error(regErr) =>
										setErrors(_ => Some((regErr.badFields, regErr.message)))
											|> Js.Promise.resolve;
								}
							});
					}} type_="submit" />
				</div>
				<div className="w-1/2 text-right">
					<Button color=Button.Gray label="Cancel" onClick={e => {
						ReactEvent.Mouse.preventDefault(e);
						setShowRegisterForm(_ => false)
					}} />
				</div>
			</div>
		</form>
	</div>
};
