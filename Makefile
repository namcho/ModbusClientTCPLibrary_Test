CFLAGS = -Wall -std=c99
DIRMB = ./Modbus
DIRMBTCP = ./Modbus/ModbusClientTCP
DIRMBCLC = ./Modbus/ModbusClientCommon
DIRMBPDU = ./Modbus/ModbusPDU

socketclient: main.o state_machine.o mctcp.o 
	gcc -o socketclient SocketClientThread.o state_machine.o mctcp.o \
	request_structure.o modbus_pdu.o -lpthread

main.o: ./src/SocketClientThread.c $(DIRMBTCP)/mctcp.h ./Statemachine/state_machine.h
	gcc $(CFLAGS) -c ./src/SocketClientThread.c

state_machine.o: ./Statemachine/state_machine.c ./Statemachine/state_machine.h
	gcc $(CFLAGS) -c ./Statemachine/state_machine.c

mctcp.o: $(DIRMBTCP)/mctcp.c $(DIRMBTCP)/mctcp.h \
	$(DIRMBTCP)/mctcp_confirmation.h $(DIRMBTCP)/mctcp_pendinglist.h \
	#request_structure.o \
	$(DIRMBCLC)/request_structure.c $(DIRMBCLC)/request_structure.h \
	$(DIRMBCLC)/mc_requester.h $(DIRMB)/modbus_interfaces.h \
	#modbus_pdu.o \
	$(MBDIRPDU)/modbus_pdu.c \
	$(DIRMBPDU)/modbus_pdu.h
	gcc $(CFLAGS) -c $(DIRMBTCP)/mctcp.c $(DIRMBCLC)/request_structure.c \
	$(DIRMBPDU)/modbus_pdu.c

request_structure.o: $(DIRMBCLC)/request_structure.c $(DIRMBCLC)/request_structure.h
	gcc $(CFLAGS) -c $(DIRMBCLC)/request_structure.c

modbus_pdu.o: $(DIRMBPDU)/modbus_pdu.c $(DIRMBPDU)/modbus_pdu.h $(DIRMBCLC)/request_structure.h
	gcc $(CFLAGS) -c $(DIRMBPDU)/modbus_pdu.c

clean:
	rm -rf *.o socketclient

