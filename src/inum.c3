module inum;
import std::collections::list;
import std::io;

fault INumError 
{
	EMPTY_INITIALISER,
	INVALID_INITIALISER,
}

//digits are stored in little endian
struct INum 
{
	bool is_negative;
	List(<char>) digits;
}

fn void INum.append_digit(&self, char digit) @private 
{
	self.digits.push(digit);
}

fn void INum.prepend_digit(&self, char digit) @private 
{
	self.digits.insert_at(0, digit);
}

fn String INum.string(&self) 
{
	DString res;
	foreach_r(d: self.digits) 
	{
		res.append_char(d + 0x30);
	}
	String res_str;
	res_str = res.copy_str();
	free((void*)res);
	return res_str;
}

fn void INum.print(&self) 
{
	String str = self.string();
	io::print(str);
}

fn void INum.printn(&self)
{
	String str = self.string();
	io::printn(str);
}

fn INum*! INum.from_string(&self, String str) 
{
	switch 
	{
		case str.len < 1: return INumError.EMPTY_INITIALISER?;
	}

	char current;
	for (ulong i = 0; i < str.len; ++i)
	{
		current = str[i];
		switch 
		{
			case current == '-' && i == 0: self.is_negative = true;
			case current == '-' && i > 0: return INumError.INVALID_INITIALISER?;
			case current.is_digit(): self.prepend_digit(current - 0x30);
			default: return INumError.INVALID_INITIALISER?;
		}
	}

	return self;
}

fn void INum.free(&self) 
{
	self.digits.free();
	free((void*)self);
}

// does not support negative numbers yet
fn INum add(INum* a, INum* b)  
{
	INum result;
	switch
	{
		case a.digits.len() < 1: return *b;
		case b.digits.len() < 1: return *a; 
	}
	INum* larger = (a.digits.len() > b.digits.len()) ? a : b;
	INum* smaller = (a.digits.len() > b.digits.len()) ? b : a;

	for (ulong i = 0; i < larger.digits.len(); ++i) 
	{
		if (i < smaller.digits.len())
		{
			char temp = larger.digits.get(i) + smaller.digits.get(i);
			char carry = temp / 10;
			char value = temp % 10;
			result.append_digit(value);
			if (carry) result.append_digit(carry);
		}
	}

	return result;
}