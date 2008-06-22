## Copyright (C) 2007,2008  Carlo de Falco, Massimiliano Culpo
##
##                   BIM - Box Integration Method Package for Octave
## 
##  BIM is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##
##  BIM is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with BIM; If not, see <http://www.gnu.org/licenses/>.
##
##
##  AUTHORS:
##
##  Carlo de Falco
##  Dublin City University
##  Glasnevin, Dublin 9, Ireland
##
##  Culpo Massimiliano
##  Bergische Universitaet Wuppertal
##  Fachbereich C - Mathematik und Naturwissenschaften
##  Arbeitsgruppe fuer Angewandte MathematD-42119 Wuppertal  Gaussstr. 20 
##  D-42119 Wuppertal, Germany

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{M}]} = @
## BIM2Aboundarymass( @var{mesh}, @var{sidelist}, @var{nodelist})
##
## Builds the boundary mass-matrix needed to apply flux boundary conditions.
##
## Input:
## @itemize @minus
## @item @var{mesh}: PDEtool-like mesh with required field "p", "e", "t".
## @item @var{sidelist}: list of the sides of the geometrical border.
## @item @var{nodelist}: (optional) list of the degrees of freedom on
## the boundary
## @end itemize 
##
## @end deftypefn

function [M] = BIM2Aboundarymass(mesh, sidelist, nodelist)

  if nargin<3
    [nodelist] = BIM2Cunknownsonside(mesh,sidelist);
  endif

  edges = [];
  for ie=sidelist
    edges = [ edges,  mesh.e([1:2 5],mesh.e(5,:)==ie)];
  endfor
  l  = sqrt((mesh.p(1,edges(1,:))-mesh.p(1,edges(2,:))).^2 +
	    (mesh.p(2,edges(1,:))-mesh.p(2,edges(2,:))).^2);
  
  dd = zeros(size(nodelist));
  
  for in = 1:length(nodelist)
    dd (in) = (sum(l(edges(1,:)==nodelist(in)))+sum(l(edges(2,:)==nodelist(in))))/2;
  endfor
  
  M = spdiag(dd);

endfunction