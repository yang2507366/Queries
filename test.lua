function printString(str1, str2)
    if str1 then
        print(str1);
    end
    if str2 then
        print(str2);
        print(string.len(str2));
        print(string.sub(str2, 1, 4));
    end
    
    return "return string from lua"..str2;
end