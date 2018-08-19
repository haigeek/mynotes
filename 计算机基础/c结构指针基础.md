# c语言指针基础知识
## 指针，引用和取值
- 指针是一个存储计算机内存地址的变量，可以用引用表示计算机的内存地址；从指针指向的内存读取的数据成为指针的取值
- 指针可以指向某些具体类型的变量地址，例如int，long和double；指针也可以是void类型，NULL指针和未初始化指针
- 根据出现位置的不同，操作符*既可以用来声明一个指针变量，也可以用作当做指针的取值。当在声明一个变量时， *表示这里声明了一个指针。其他情况用 *表示指针的取值。
- &是地址操作符，用来引用一个内存地址。通用在变量名字前使用&操作符，我们可以得到该内存的内存地址。
```c
int *ptr;//声明一个int指针
int val=1;//声明一个int值
ptr=&val;//为指针分配一个int值的引用
int deref=*ptr;
printf("%d\n",deref);//对指针进行取值,打印存储在指针地址中的内容
```
## void指针，NULL指针和未初始化指针
一个指针可以被声明为void类型，比如void *x；一个指针可以被赋值为NULL；一个指针声明之后但没有被赋值，叫做未初始化指针
```c
int *uninit;//int指针未初始化
int *nullptr=NULL;//初始化未NULL
void *vptr;//void指针未初始化
int val=1;
int *iptr;
int *castptr;
//void类型可以存储为任意类型的指针或者引用
iptr=&val;
vptr=iptr;
printf("iptr=%p,vptr=%p\n",iptr,vptr);
//通过显式转换，可以把一个void指针转换为int指针，并取值
castptr=(int*)vptr;
printf("*castptr=%d\n",*castptr);
//打印null和未初始化指针
printf("uninit=%p,nillptr=%p\n",uninit,nullptr);
```
## 指针和数组
数组和指针不是同一种结构因此不可以相互转换，而数组变量指向了数组的第一个元素的内存地址；不能把指针赋值给数组变量，也不可以将一个数组变量赋值给另外一个数组，然而可以将一个数组变量赋值给指针。把数组变量赋值给指针的时候，实际上是把指向数组的第一个元素的地址赋给指针。
```c
int array[4]={1,2,3,0};
int *ptr=array;//这个赋值与int *ptr=&array[0]效果相同；需要注意指针需要和数组的元素类型保持一致
```
## 指针和结构体
就像数组一样，指向结构体的指针存储了结构体第一个元素的内存地址。与数组指针一样，结构体的指针必须声明和结构体类型保持一致，或者声明为void类型。
```c
struct person{
    int age;
    char *name;
};
struct person first;
struct person *ptr;
first.age=21;
char *fullname="full name";
first.name=fullname;
ptr=&first;
printf("age=%d,name=%s\n",first.age,ptr->name);
```
.和->的区别：结构体实例可以使用使用 . 符号访问age变量。对于结构体实例的指针，我们可以通过‘->’符号访问变量，也可以使用(*ptr).name来访问
