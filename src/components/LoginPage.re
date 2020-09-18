[@react.component]
let make = () =>{
	let (showRegisterForm, setShowRegisterForm) = React.useState(() => false);
	let (loginMessage, setLoginMessage) = React.useState(() => None);
	<div className="bg-gray-200 min-h-screen min-w-full flex flex-col items-center">
		<div className="bg-white w-4/5 sm:w-4/5 md:w-2/3 lg:w-1/2 mt-10 shadow-md">
			{
				switch (showRegisterForm) {
					| true => <RegistrationForm setShowRegisterForm=setShowRegisterForm setLoginMessage=setLoginMessage />
					| false => <LoginForm setShowRegisterForm=setShowRegisterForm loginMessage=loginMessage />
				}
			}
		</div>
	</div>
};