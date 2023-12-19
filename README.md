# Nmap Parsell - Parshell
### Funcionalidades del Script

1. **Inicialización de Variables**: El script comienza inicializando una serie de variables como `ip`, `port`, `file`, `service`, `script`, y otras relacionadas con el control de flujo y opciones del script.

2. **Menú de Ayuda (`show_help`)**: Proporciona un menú de ayuda que describe las opciones disponibles en el script, como `--ip`, `--port`, `--file`, `--service`, `--endpoint`, `--nmapScan`, `--script`, `--printAll`, `--onGoing`, y `--addDone`.

3. **Procesamiento de Argumentos**: El script procesa los argumentos pasados en la línea de comandos, permitiendo al usuario especificar diferentes opciones como la dirección IP, el puerto, el nombre del archivo, el nombre del servicio, etc.

4. **Funcionalidades Específicas**:
   - **Endpoint y Nmap Scan**: Puede mostrar información en formato `ip:puerto` y realizar escaneos Nmap específicos basados en los puertos e IPs proporcionados.
   - **Print All (`--printAll`)**: Devuelve la relación IP-Puertos sin entrar en detalles, lo que facilita obtener todos los puertos y servicios únicos.
   - **On Going (`--onGoing`)**: Muestra información sobre servicios o puertos que aún no se han escaneado.
   - **Add Done (`--addDone`)**: Añade información al archivo `.done`.

5. **Análisis de Archivos `.nmap`**: El script puede analizar archivos con la extensión `.nmap`, extrayendo y procesando información relevante como IPs, puertos y servicios.

### Ejemplos de Uso

1. **Mostrar Menú de Ayuda**:
   ```bash
   ./parshell.sh -h
   ```

2. **Analizar una Dirección IP Específica**:
   ```bash
   ./parshell.sh --ip 192.168.1.1
   ```

3. **Analizar un Puerto Específico**:
   ```bash
   ./parshell.sh --port 80
   ```

4. **Usar un Archivo Específico para el Análisis**:
   ```bash
   ./parshell.sh --file example.nmap
   ```

5. **Generar Comandos Nmap para Escaneos Específicos**:
   ```bash
   ./parshell.sh --nmapScan --endpoint --script "vuln"
   ```

6. **Listar Todos los Puertos y Servicios Únicos**:
   ```bash
   ./parshell.sh --printAll
   ```

7. **Agregar Información al Archivo `.done`**:
   ```bash
   ./parshell.sh --addDone "192.168.1.1:80"
   ```
