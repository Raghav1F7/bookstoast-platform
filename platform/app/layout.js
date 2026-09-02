import './globals.css';

export const metadata = {
  title: 'Bookstoast — Launch your scholarly journal',
  description: 'Bookstoast helps researchers launch, publish, and grow scholarly journals.',
};

export default function RootLayout({children}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
