USE [MaBanque]
GO
/****** Object:  Table [dbo].[client]    Script Date: 13/08/2023 21:09:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[client](
	[id_client] [int] IDENTITY(1,1) NOT NULL,
	[nom] [varchar](100) NOT NULL,
	[prenom] [varchar](100) NOT NULL,
	[username] [varchar](100) NOT NULL,
	[email] [varchar](100) NOT NULL,
	[password] [varchar](100) NOT NULL,
	[phone] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_client] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [un_username] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[client_compte]    Script Date: 13/08/2023 21:09:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[client_compte](
	[id_client] [int] NOT NULL,
	[id_compte] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_client] ASC,
	[id_compte] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[compte]    Script Date: 13/08/2023 21:09:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[compte](
	[id_compte] [int] IDENTITY(1,1) NOT NULL,
	[numero_compte] [varchar](100) NOT NULL,
	[devise] [varchar](3) NOT NULL,
	[type] [varchar](2) NOT NULL,
	[solde] [decimal](23, 3) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_compte] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[operation]    Script Date: 13/08/2023 21:09:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[operation](
	[id_operation] [int] IDENTITY(1,1) NOT NULL,
	[type_op] [varchar](3) NOT NULL,
	[montant] [decimal](23, 3) NOT NULL,
	[date_op] [date] NOT NULL,
	[id_compte] [int] NULL,
	[id_client] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_operation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[client_compte]  WITH CHECK ADD FOREIGN KEY([id_client])
REFERENCES [dbo].[client] ([id_client])
GO
ALTER TABLE [dbo].[client_compte]  WITH CHECK ADD FOREIGN KEY([id_compte])
REFERENCES [dbo].[compte] ([id_compte])
GO
ALTER TABLE [dbo].[operation]  WITH CHECK ADD FOREIGN KEY([id_client])
REFERENCES [dbo].[client] ([id_client])
GO
ALTER TABLE [dbo].[operation]  WITH CHECK ADD FOREIGN KEY([id_compte])
REFERENCES [dbo].[compte] ([id_compte])
GO
ALTER TABLE [dbo].[compte]  WITH CHECK ADD  CONSTRAINT [chk_devise] CHECK  (([devise]='USD' OR [devise]='EUR' OR [devise]='GDE'))
GO
ALTER TABLE [dbo].[compte] CHECK CONSTRAINT [chk_devise]
GO
ALTER TABLE [dbo].[compte]  WITH CHECK ADD  CONSTRAINT [chk_type] CHECK  (([type]='CE' OR [type]='CC'))
GO
ALTER TABLE [dbo].[compte] CHECK CONSTRAINT [chk_type]
GO
ALTER TABLE [dbo].[operation]  WITH CHECK ADD  CONSTRAINT [chk_typeOp] CHECK  (([type_op]='VIR' OR [type_op]='RET' OR [type_op]='DPT'))
GO
ALTER TABLE [dbo].[operation] CHECK CONSTRAINT [chk_typeOp]
GO
/****** Object:  StoredProcedure [dbo].[AddClientWithCompte]    Script Date: 13/08/2023 21:09:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[AddClientWithCompte]
(
	@nom varchar(100),
	@prenom varchar(100),
	@username varchar(100),
	@email varchar(100),
	@password varchar(100),
	@phone varchar(100),
	@devise varchar(3),
	@type varchar(2),
	@solde decimal(23,3)
)
as

declare @numeroCompte varchar(100) = concat(cast(ceiling(rand()*100) as varchar(100)),@phone)


if(exists(select * from client where username=@username))
	begin	
		insert into compte(numero_compte,devise,type,solde) values(@numeroCompte,@devise,@type,@solde)
		insert into client_compte(id_client,id_compte) values ((select id_client from client where username=@username),(select max(id_compte) from compte))
	end
else
	begin
		insert into client(nom,prenom,username,email,password,phone) values(@nom,@prenom,@username,@email,@password,@phone)
		insert into compte(numero_compte,devise,type,solde) values(@numeroCompte,@devise,@type,@solde)
		insert into client_compte(id_client,id_compte) values ((select max(id_client) from client),(select max(id_compte) from compte))
	end
GO
/****** Object:  StoredProcedure [dbo].[AjouterOperation]    Script Date: 13/08/2023 21:09:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[AjouterOperation]
(
	@type varchar(100),
	@montant decimal(10,3),
	@numCompte varchar(100),
	@numCompteBene varchar(100) = null,
	@dateOp datetime
)
as
begin
declare @idCompte int;
declare @idClient int;
declare @idCompteBene int = 0;
declare @idClientBene int = 0;

select @idCompte = id_compte from compte where numero_compte = @numCompte;
select @idClient = id_client from client_compte where id_compte = @idcompte;
insert into operation values(@type,@montant,@dateOp,@idCompte,@idClient);

if(@type = 'Dépot')
   update compte set solde= solde + @montant where id_compte = @idCompte;
else if(@type = 'Retrait')
	update compte set solde= solde - @montant where id_compte = @idCompte;
else if(@type = 'virement')
    begin
	   select @idCompteBene = id_compte from compte where numero_compte = @numCompteBene;
	   select @idClientBene = id_client from client_compte where id_compte = @idCompteBene;
	   insert into operation values(@type,@montant,@dateOp,@idCompteBene,@idClientBene);
	   update compte set solde= solde - @montant where id_compte = @idCompte;
	   update compte set solde= solde + @montant where id_compte = @idCompteBene;
	end;

end
GO
