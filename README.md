# blockchain-td5


# Fonction du programme

Afin de faire fonctionner ce programme, il faut utiliser ganache, l'implémentation test net n'ayant pas pu etre effectué.

L'adresse 1 ayant servi d'adresse pour deployer les contrats a pour role d'admin et sert donc a whitelister les autres adresses (il faut également la white lister en elle même).

Une fois whitelisté, l'adresse pourra être utilisé pour ajouter des animaux mais également les faire s'accoupler ainsi que declarer leuyr décès. 

Un utilisateur pourra également lancer une enchère pour un de ses animaux. les autres utilisateurs auront alors 48h pour enchérir. Après 48h, l'utilisateur ayant gagné l'enchère pourra claim son nouvel animal (La gestion de la vente niveau solde en ether n'a pas pu être implémenté)
