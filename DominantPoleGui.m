function varargout = DominantPoleGui(varargin)
% DOMINANTPOLEGUI M-file for DominantPoleGUI.fig
%      DOMINANTPOLEGUI, by itself, creates a new DOMINANTPOLEGUI or raises the existing
%      singleton*.
%
%      H = DOMINANTPOLEUI returns the handle to a new DOMINANTPOLEGUI or the handle to
%      the existing singleton*.
%
%      DOMINANTPOLEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DOMINANTPOLEGUI.M with the given input arguments.
%
%      DOMINANTPOLEGUI('Property','Value',...) creates a new DOMINANTPOLEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DominantPoleGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DominantPoleGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DominantPoleGui

% Last Modified by GUIDE v2.5 03-Feb-2009 18:27:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DominantPoleGui_OpeningFcn, ...
    'gui_OutputFcn',  @DominantPoleGui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DominantPoleGui is made visible.
function DominantPoleGui_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for DominantPoleGui
handles.output = hObject;
handles.realPole=-1;
handles.complexPole=[-1+3j -1-3j];
set(handles.RB_first,'value',1);
set(handles.RB_second,'value',0);

% Update handles structure
guidata(hObject, handles);
makePlots(handles)


% --- Outputs from this function are returned to the command line.
function varargout = DominantPoleGui_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in PB_Quit.
function PB_Quit_Callback(hObject, eventdata, handles)
delete(gcf)


function ET_Pole_Callback(hObject, eventdata, handles)
p=str2double(get(hObject,'String'));
if p>-0.1,
    p=-0.1;
elseif p<-10,
    p=-10;
end
set(hObject,'String',num2str(p));
makePlots(handles);


% --- Executes during object creation, after setting all properties.
function ET_Pole_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RB_second.
function RB_second_Callback(hObject, eventdata, handles)
set(handles.RB_first,'value',0);
set(handles.RB_second,'value',1);
makePlots(handles);


% --- Executes on button press in RB_first.
function RB_first_Callback(hObject, eventdata, handles)
set(handles.RB_first,'value',1);
set(handles.RB_second,'value',0);
makePlots(handles);


function makePlots(handles)
p=str2double(get(handles.ET_Pole,'String'));
ax=handles.plotStep; axes(ax);

if get(handles.RB_first,'value');
    exactDen=poly([p handles.realPole]);
    dpDen=poly(handles.realPole);
    exactTF=tf(exactDen(end),exactDen);
    dpTF=tf(dpDen(end),dpDen);
    tmax=ceil(4/min(-roots(exactDen)));
    t=linspace(0,tmax);
    yExact=step(exactTF,t);
    yDP=step(dpTF,t);
    plot(t,yExact,t,yDP);
    legend('Exact','Approx','Location','se');
    set(handles.TXT_Ex,'String',...
        'The approximation shown considers only the pole at s=-1.');
else
    exactDen=poly([p handles.complexPole]);
    dpDen1=poly(p);
    dpDen2=poly(handles.complexPole);
    exactTF=tf(exactDen(end),exactDen);
    pole(exactTF);
    dpTF1=tf(dpDen1(end),dpDen1);
    dpTF2=tf(dpDen2(end),dpDen2);
    tmax=ceil(4/min(-real(roots(exactDen))));
    t=linspace(0,tmax);
    [yExact]=step(exactTF,t);
    [yDP1]=step(dpTF1,t);
    [yDP2]=step(dpTF2,t);
    plot(t,yExact,t,yDP1,t,yDP2);
    legend('Exact','1^{st} order approx','2^{nd} order approx',...
        'Location','se');
    set(handles.TXT_Ex,'String',...
        'Both first and second order approximations are shown.'); 
end


set(ax,'XLim',[0 tmax]);
set(ax,'YLim',[0 1.4]);    set(ax,'yTick',0:0.2:1.4);
title('Exact output & Dominant Pole output');
xlabel('Time'); ylabel('Output');
grid on;


ax=handles.plotPZ;  axes(ax);
plot(real(pole(exactTF)),imag(pole(exactTF)),'bx','MarkerSize',10);
set(ax,'XLim',[-10 0]);    set(ax,'XTick',-10:2:0);
set(ax,'YLim',[-4 4]);    set(ax,'yTick',-2:2:2);
title('Pole Zero Map');
xlabel('Real'); ylabel('Imaginary');
grid on;
