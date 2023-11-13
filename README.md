# Trabajo de Fin de Grado: Control de elementos de un automóvil mediante un sistema empotrado

### Autor(a): Sheila Martínez Gómez
### Tutor(a)(es): Jesús González Peñalver

## Resumen

El grueso de este Trabajo de Fin de Grado consiste en la programación de
un sistema empotrado para controlar diversas funciones que realiza un vehículo,
utilizando un RTOS (un sistema operativo de tiempo real) para garantizar la
respuesta acotada a las señales enviadas por el usuario.
La realización del trabajo comienza con una investigación acerca de los diferentes
subsistemas que conforman un vehículo, así como su evolución e impacto
en la sociedad actual. Una vez adquirida la base de conocimientos necesarios,
se procede a realizar la programación de la centralita basada en el
Sistema Empotrado, además de una interfaz de usuario que permita iniciar y
detener las tareas asociadas a las funciones del automóvil.
Finalmente se construye una maqueta de un vehículo mostrando los sistemas
desarrollados durante el proyecto en funcionamiento.

## Abstract

The aim of this Final Degree Project is the programming of an embedded
system to control various functions performed by a vehicle, using a RTOS (realtime
operating system) to guarantee a time-delimited response to the signals
provided by the user.
The work starts with an investigation of the different subsystems that make
up a vehicle, as well as their evolution and impact on today’s society. Once
the required knowledge base has been acquired, the programming of the ECU
(Electronic ControlUnit) will be carried out, aswell as the user interface to start
and stop the task associated with the car’s functions.
Finally, a car model is built to showthe functioning of the developed subsystems
during the project.
___

La documentación de este proyecto está realizada con `LaTeX`, por lo
tanto para generar el archivo PDF necesitaremos instalar `TeXLive` en
nuestra distribución.

Una vez instalada, tan solo deberemos situarnos en el directorio `doc` y ejecutar:

`
$ pdflatex proyecto.tex
`

Seguido por

    bibtex proyecto
    
y de nuevo

    pdflatex proyecto.tex

O directamente

    make
    
(que habrá que editar si el nombre del archivo del proyecto cambia)

# INSTRUCCIONES

Lee [INSTALL.md](INSTALL.md) para las instrucciones de uso.
