%{
static void
convert_SbVec2d_array(PyObject *input, double temp[2])
{
  if (PySequence_Check(input) && (PySequence_Size(input) == 2) &&
      PyNumber_Check(PySequence_GetItem(input, 0)) && 
      PyNumber_Check(PySequence_GetItem(input, 1))) {
    temp[0] = PyFloat_AsDouble(PySequence_GetItem(input, 0));
    temp[1] = PyFloat_AsDouble(PySequence_GetItem(input, 1));
  } else {
    PyErr_SetString(PyExc_TypeError, "expected a sequence with 2 floats");
    PyErr_Print();
  } 
}
%}

%typemap(in) double v[2] (double temp[2]) {
  convert_SbVec2d_array($input, temp);
  $1 = temp;
}

%rename(SbVec2d_vec) SbVec2d::SbVec2d(const double v[2]);
%rename(SbVec2d_dd) SbVec2d::SbVec2d(const double x, const double y);

%feature("shadow") SbVec2d::SbVec2d %{
def __init__(self,*args):
   if len(args) == 1:
      self.this = apply(_pivy.new_SbVec2d_vec,args)
      self.thisown = 1
      return
   elif len(args) == 2:
      self.this = apply(_pivy.new_SbVec2d_dd,args)
      self.thisown = 1
      return
   self.this = apply(_pivy.new_SbVec2d,args)
   self.thisown = 1
%}

%rename(setValue_dd) SbVec2d::setValue(const double x, const double y);

%feature("shadow") SbVec2d::setValue(const double vec[2]) %{
def setValue(*args):
   if len(args) == 3:
      return apply(_pivy.SbVec2d_setValue_dd,args)
   return apply(_pivy.SbVec2d_setValue,args)
%}

/* GR: add operator overloading methods instead of the global functions */
%extend SbVec2d {
    SbVec2d __add__( const SbVec2d &u)
    {
        return *self + u;
    };
    
    SbVec2d __sub__( const SbVec2d &u)    
    {
       return *self - u;
    };
    
    SbVec2d __mul__( const float d)
    {
       return *self * d;
    };
    
    SbVec2d __rmul__( const float d)
    {
           return *self * d;
    };
    
    SbVec2d __div__( const float d)
    {
        return *self / d;
    };
       
    int __eq__( const SbVec2d &u )
    {
        return *self == u;
    };
    
    int __nq__( const SbVec2d &u )
    {
        return *self != u;
    };
}

%apply double *OUTPUT { double & x, double & y };

%ignore SbVec2d::getValue(void) const;

// add a method for wrapping c++ operator[] access
%extend SbVec2d {
  double __getitem__(int i) {
    return (self->getValue())[i];
  }
}
