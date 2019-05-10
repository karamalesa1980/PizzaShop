function something()
{

	var x = window.localStorage.getItem('ccc');

	x = x * 1 + 1;

	window.localStorage.setItem('ccc', x);


	alert(x);
}

function add_to_cart(id)
{
	alert('вы выбрали' + id);
}