#include <stdio.h>
#include <stdlib.h>

typedef long long Unum;
#define NAMELEN 80

struct Emp {
  Unum          id;
  char          name[NAMELEN];
  int           salary;
  struct Emp *next;
};

struct Emp *Emp_list = 0;

Unum Emp_get_id(struct Emp *emp) { return emp->id; }

void Emp_set_id(struct Emp *emp, Unum id) { emp->id = id; }

void Emp_get_name(struct Emp *emp, char *name) {
  int i;
  for (i=0;i<NAMELEN; i++) name[i] = emp->name[i];
}

void Emp_set_name(struct Emp *emp, char *name) {
  int i;
  for (i=0;i<NAMELEN; i++) emp->name[i] = name[i];
}

int Emp_get_salary(struct Emp *emp) { return emp->salary; }

void Emp_set_salary(struct Emp *emp, int salary) { emp->salary = salary; }

struct Emp * Emp_get_next(struct Emp *emp) { return emp->next; }

void Emp_set_next(struct Emp *emp, struct Emp *next) { emp->next = next; }

void Emp_Emp(struct Emp *emp, Unum id, char *name, int salary) {
  Emp_set_id(emp, id); Emp_set_name(emp, name); Emp_set_salary(emp, salary);
  Emp_set_next(emp, 0);
}

struct Emp *Emp_new() { return malloc(sizeof(struct Emp)); }


void Emp_add(Unum id, char *name, int salary) {
  struct Emp *emp = Emp_new();
  Emp_Emp(emp, id, name, salary);
  Emp_set_next(emp, Emp_list);
  Emp_list = emp;
}

int mystery()
{
  int total = 0;
  struct Emp *emp = Emp_list;
  while (emp) { 
    total += emp->salary;
    emp=emp->next;
  }
  return total;
}

void printEmps(void)
{
  struct Emp *e;
  int i;

  for (e = Emp_list, i=0;
       e != NULL;
       e=e->next, i++) {
    printf("%d: %p: %lld %s %d\n", i, e,
	   e->id, e->name, e->salary);
  } 
}

int main(int argc, char **argv)
{
  int n=10;
  int i=0;
  int s;
  char name[NAMELEN];
  
  if (argc>1) n=atoi(argv[1]);
  
  for (i=0; i<n; i++) {
    snprintf(name, NAMELEN, "Employee %d", i);
    s = random();
    s = (s<0) ? -1*s : s;
    Emp_add(i, name, s);
  }
  printEmps();
  printf("%d\n", mystery());
  return 0;
}
