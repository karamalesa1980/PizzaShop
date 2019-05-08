function something()
{

	var x = window.localStorage.getItem('ccc');

	x = x * 1 + 1;

	window.localStorage.setItem('ccc', x);


	alert(x);
}