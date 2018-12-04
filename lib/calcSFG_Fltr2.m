function [Coeffs, OutMtrx, KfMtrx] = calcSFG_Fltr2(lddr)
%   [Coeffs, OutMtrx, KfMtrx] = calcSFG_Fltr2(lddr) used to design analog SFG filter
%   simulation ladder filter having capacitors and complex reactances only
%
%   Toolbox for the Design of Complex Filters
%   Copyright (C) 2018  Kenneth Martin
%
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.
%


  % 3 capacitors for two loss poles plus one loss pole at infinity
  NmbElems = lddr.size;
  N = 2*(NmbElems -1)/3 + 1;
  if mod(N, 2) == 0
    error('The filter order must be odd to make a digital SFG');
  end

  elem0 = ladderElem(0, 0, 0, 0, 'SHC');
  elems = lddr.ladderElems;

  Coeffs=[];
  Coeffs(1, :) = calcSFG_Coeffs2(elem0, elems(1), elems(2), 1/lddr.R1, 1/lddr.R1);
  Coeffs(N, :) = calcSFG_Coeffs2(elems(NmbElems - 1), elems(NmbElems), elem0, 0, 1/lddr.R2);

  OutMtrx = zeros(N,N);
  OutMtrx(1,2) = real(Coeffs(1,3));
  OutMtrx(N,N-1) = real(Coeffs(N,1));

  elemNmb = 2;
  for i = 2:(N - 1)
    if mod(i, 2) == 0
      Coeffs(i, :) = calcSFG_Coeffs2(elems(elemNmb), elem0, elems(elemNmb + 1), 0, 0); % shunt element is 0
      elemNmb = elemNmb + 1;
    else
      Coeffs(i, :) = calcSFG_Coeffs2(elems(elemNmb), elems(elemNmb + 1), elems(elemNmb + 2), 0, 0);
      elemNmb = elemNmb + 2;
    end
    OutMtrx(i,i-1) = real(Coeffs(i,1));
    OutMtrx(i,i+1) = real(Coeffs(i,3));
  end

  KfMtrx = zeros(N,N);
  KfMtrx(1,1) = -Coeffs(1,5);
  KfMtrx(1,2) = Coeffs(1,4);
  KfMtrx(N,N) = -Coeffs(N,5);
  KfMtrx(N,N-1) = Coeffs(N,2);

  for i = 2:(N - 1)
    KfMtrx(i,i-1) = Coeffs(i,2);
    KfMtrx(i,i+1) = Coeffs(i,4);
    KfMtrx(i,i) = -(Coeffs(i,2) + Coeffs(i,4));
  end