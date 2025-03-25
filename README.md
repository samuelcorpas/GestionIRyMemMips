# 🧠 Gestión de Memoria e IRQ en MIPS 🚀

**AUTORES: SAMUEL CORPAS PUERTO y DANIEL SALAS SAYAS

Proyecto académico enfocado en el diseño y simulación de componentes para la arquitectura MIPS en VHDL, integrando gestión de memoria e interrupciones (IRQ).

---

## 📜 Instalación y Uso  

1. Clona este repositorio:  
   ```bash
   git clone https://github.com/samuelcorpas/GestionIRyMemMips.git
   cd GestionIRyMemMips
   ```

2. Abre los archivos `.vhd` en tu entorno de simulación.  
3. Simula y analiza cada componente de manera modular o en conjunto.  
4. Consulta el documento PDF para más detalles del diseño.

---

## 📂 Estructura del proyecto

```plaintext
.
├── Exception_manager_2024_completar.vhd        # Gestión de excepciones
├── Mips_segmentado_IRQ_2024_completar.vhd      # MIPS segmentado con IRQ
├── UC_Mips_2024_completar.vhd                  # Unidad de Control MIPS
├── UA_2024_completar.vhd                       # Unidad Aritmética
├── UC_MC_2024_completar.vhd                    # Control de Memoria y Cache
├── UD_2024_completar.vhd                       # Unidad de Decodificación
├── memoriaRAM_*.vhd                            # Módulos de memoria RAM
├── Memoria Proyecto 2.pdf                      # Documentación del proyecto
├── LICENSE                                     # Licencia MIT
└── README.md                                   # Este archivo
```

---

## ✨ Notas adicionales

- El diseño busca emular un entorno realista de un procesador MIPS con soporte para interrupciones.
- Todos los componentes están descritos en VHDL y son simulables.
- El proyecto es fácilmente escalable a sistemas embebidos o FPGAs reales.

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. ¡Siéntete libre de usarlo, modificarlo y compartirlo!
